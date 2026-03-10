#Requires AutoHotkey v2.0

RegisterFeatureTests(runner) {
    runner.Add("AutoForwardFeature starts and stops movement", TestAutoForwardFeatureStartStop)
    runner.Add("AutoForwardFeature stops when scene leaves normal", TestAutoForwardFeatureStopsOnSceneChange)
    runner.Add("CameraControlFeature ticks mouse movement in normal scene", TestCameraControlFeatureMovesMouse)
    runner.Add("WindowPositionFeature moves the window into a new slot", TestWindowPositionFeatureMovesWindow)
}

TestAutoForwardFeatureStartStop() {
    hotkeys := FakeHotkeys()
    input := FakeInputService()
    hud := FakeHud()
    scene := FakeSceneService("normal")
    state := FakeStateService()
    bus := EventBus()
    logger := FakeLogger()

    feature := AutoForwardFeature(hotkeys, input, scene, state, bus, hud, logger)
    feature.Initialize()

    Assert.Equal(3, hotkeys.entries.Length)

    feature.HandleToggle()
    feature.HandleManualStop()

    Assert.ArrayEqual(["down|w", "up|w"], input.events)
    Assert.ArrayEqual(["1|auto forward [ON]", "1|auto forward [OFF]"], hud.messages)
}

TestAutoForwardFeatureStopsOnSceneChange() {
    hotkeys := FakeHotkeys()
    input := FakeInputService()
    hud := FakeHud()
    scene := FakeSceneService("normal")
    state := FakeStateService()
    bus := EventBus()
    logger := FakeLogger()

    feature := AutoForwardFeature(hotkeys, input, scene, state, bus, hud, logger)
    feature.Initialize()
    feature.HandleToggle()

    scene.current := "menu"
    feature.HandleSceneChanged(["menu"], "normal", "detect")

    Assert.ArrayEqual(["down|w", "up|w"], input.events)
}

TestCameraControlFeatureMovesMouse() {
    hotkeys := FakeHotkeys()
    timers := FakeTimers()
    input := FakeInputService()
    scene := FakeSceneService("normal")
    logger := FakeLogger()

    feature := CameraControlFeature(hotkeys, timers, input, scene, logger)
    feature.Initialize()
    feature.HandleDown("Left")
    feature.HandleDown("Up")
    feature.Tick()
    feature.HandleUp("Left")
    feature.HandleUp("Up")

    Assert.Equal(8, hotkeys.entries.Length)
    Assert.True(input.events.Length >= 1, "Expected at least one mouse move event")
    Assert.Equal("move|-20|-20", input.events[1])
}

TestWindowPositionFeatureMovesWindow() {
    hotkeys := FakeHotkeys()
    window := FakeWindowService()
    hud := FakeHud()
    logger := FakeLogger()

    feature := WindowPositionFeature(hotkeys, window, hud, logger)
    feature.Initialize()
    feature.position := [1, 1]
    feature.MoveBy(1, 0)

    Assert.Equal(4, hotkeys.entries.Length)
    Assert.Equal(1, window.moves.Length)
    Assert.Equal(2, feature.position[1])
    Assert.Equal(1, feature.position[2])
}

class FakeStateService {
    __New() {
        this.flags := Map()
    }

    Has(name) {
        return this.flags.Has(name)
    }
}
