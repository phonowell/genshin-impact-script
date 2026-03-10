#Requires AutoHotkey v2.0

RegisterStateTests(runner) {
    runner.Add("StateRules loads cryo and hydro colors", TestStateRulesLoadsElementColors)
    runner.Add("StateDetector detects core flags and emits only on change", TestStateDetectorDetectsFlagsAndDeduplicates)
}

TestStateRulesLoadsElementColors() {
    path := MakeTempStateRules()
    rules := StateRules(path, FakeLogger())
    rules.Load()

    Assert.ArrayEqual([0x9FEFFF, 0x9FEFFF], rules.GetElementColors("cryo"))
    Assert.ArrayEqual([0x4DE6FF, 0x4DE6FF], rules.GetElementColors("hydro"))

    try FileDelete(path)
}

TestStateDetectorDetectsFlagsAndDeduplicates() {
    path := MakeTempStateRules()
    rules := StateRules(path, FakeLogger())
    rules.Load()

    logger := FakeLogger()
    color := FakeColorService()
    scene := FakeSceneService("normal")
    bus := EventBus()
    probe := StateChangeProbe()

    bus.On("state:changed", ObjBindMethod(probe, "Record"))
    color.SetFindAllCallback(StateFindAllCallback)
    color.SetFindAnyCallback(StateFindAnyCallback)

    detector := StateDetector(color, scene, rules, bus, logger)
    first := detector.Detect()
    second := detector.Detect()

    Assert.ArrayEqual(["single", "domain", "cryo", "frozen", "free", "ready"], first)
    Assert.ArrayEqual(first, second)
    Assert.True(detector.Has("ready"))
    Assert.False(detector.Has("hydro"))
    Assert.Equal(1, probe.count, "state:changed should only emit on the first detect")

    try FileDelete(path)
}

StateFindAllCallback(colors, area, step := 2) {
    if IsArrayColors2(colors, [0x38425C, 0xFFFFFF]) && AreaStartsAt2(area, "1%", "9%") {
        return true
    }

    if IsArrayColors2(colors, [0x9FEFFF, 0x9FEFFF]) && AreaStartsAt2(area, "42%", "88%") {
        return true
    }

    if IsScalarColor2(colors, 0xF05C4A) && AreaStartsAt2(area, "73%", "48%") {
        return true
    }

    if IsArrayColors2(colors, [0xFFFFFF, 0x323232]) && AreaStartsAt2(area, "72%", "53%") {
        return true
    }

    if IsArrayColors2(colors, [0xFFFFFF, 0x323232]) && AreaStartsAt2(area, "94%", "80%") {
        return true
    }

    return false
}

StateFindAnyCallback(colors, area, step := 2) {
    if IsScalarColor2(colors, 0xFFFFFF) && AreaStartsAt2(area, "18%", "2%") {
        return [100, 100, 0xFFFFFF]
    }

    if IsArrayColors2(colors, [0x006699, 0x408000]) && AreaStartsAt2(area, "18%", "2%") {
        return false
    }

    if IsArrayColors2(colors, [0x96D722, 0xFF6666]) && AreaStartsAt2(area, "88%", "25%") {
        return [200, 200, 0x96D722]
    }

    return false
}

MakeTempStateRules() {
    path := A_Temp "\gis-ahkv2-state-rules.ini"
    try FileDelete(path)

    FileAppend(
        "[elements]`n"
        . "cryo_primary = 0x9FEFFF`n"
        . "cryo_secondary = 0x9FEFFF`n"
        . "hydro_primary = 0x4DE6FF`n"
        . "hydro_secondary = 0x4DE6FF`n",
        path,
        "UTF-8"
    )

    return path
}

AreaStartsAt2(area, x, y) {
    return IsObject(area)
        && area.Length >= 2
        && area[1][1] = x
        && area[1][2] = y
}

IsScalarColor2(colors, expected) {
    return !IsObject(colors) && colors = expected
}

IsArrayColors2(colors, expected) {
    if !IsObject(colors) || colors.Length != expected.Length {
        return false
    }

    loop expected.Length {
        if (colors[A_Index] != expected[A_Index]) {
            return false
        }
    }

    return true
}

class StateChangeProbe {
    __New() {
        this.count := 0
    }

    Record(*) {
        this.count += 1
    }
}
