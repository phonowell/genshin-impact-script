#Requires AutoHotkey v2.0

RegisterSceneTests(runner) {
    runner.Add("SceneDetector detects normal scene", TestSceneDetectorDetectsNormal)
    runner.Add("SceneDetector detects menu map scene", TestSceneDetectorDetectsMenuMap)
    runner.Add("SceneDetector returns unknown when window is inactive", TestSceneDetectorInactiveWindow)
}

TestSceneDetectorDetectsNormal() {
    logger := FakeLogger()
    window := FakeWindowService()
    color := FakeColorService()
    bus := EventBus()
    changes := SceneChangeProbe()

    bus.On("scene:changed", ObjBindMethod(changes, "Record"))
    color.SetFindAllCallback(SceneFindAllNormal)
    color.SetGetColorCallback(SceneGetColorDefault)

    detector := SceneDetector(color, window, bus, logger)
    result := detector.Detect()

    Assert.ArrayEqual(["normal"], result)
    Assert.Equal("normal", detector.Get())
    Assert.Equal(1, changes.count)
}

TestSceneDetectorDetectsMenuMap() {
    logger := FakeLogger()
    window := FakeWindowService()
    color := FakeColorService()
    bus := EventBus()

    color.SetFindAllCallback(SceneFindAllMenuMap)
    color.SetGetColorCallback(SceneGetColorDefault)

    detector := SceneDetector(color, window, bus, logger)
    result := detector.Detect()

    Assert.ArrayEqual(["menu", "map"], result)
    Assert.Equal("menu", detector.Get())
}

TestSceneDetectorInactiveWindow() {
    logger := FakeLogger()
    window := FakeWindowService()
    color := FakeColorService()
    bus := EventBus()

    window.active := false
    detector := SceneDetector(color, window, bus, logger)
    result := detector.Detect()

    Assert.ArrayEqual(["unknown"], result)
    Assert.Equal("unknown", detector.Get())
}

SceneFindAllNormal(colors, area, step := 2) {
    return IsScalarColor(colors, 0xFFFFFF)
        && AreaStartsAt(area, "2%", "17%")
}

SceneFindAllMenuMap(colors, area, step := 2) {
    if IsArrayColors(colors, [0x3B4255, 0xECE5D8]) && AreaStartsAt(area, "95%", "3%") {
        return true
    }

    if IsScalarColor(colors, 0xEDE5DA) && AreaStartsAt(area, "1%", "38%") {
        return true
    }

    return false
}

SceneGetColorDefault(point) {
    return -1
}

AreaStartsAt(area, x, y) {
    return IsObject(area)
        && area.Length >= 2
        && area[1][1] = x
        && area[1][2] = y
}

IsScalarColor(colors, expected) {
    return !IsObject(colors) && colors = expected
}

IsArrayColors(colors, expected) {
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

class SceneChangeProbe {
    __New() {
        this.count := 0
    }

    Record(*) {
        this.count += 1
    }
}
