class CameraControlFeature {
    __New(hotkeys, timers, input, scene, logger := "") {
        this.hotkeys := hotkeys
        this.timers := timers
        this.input := input
        this.scene := scene
        this.logger := logger
        this.started := false
        this.pressed := Map(
            "Left", false,
            "Right", false,
            "Up", false,
            "Down", false
        )
        this.timerName := "feature/camera-control"
    }

    Initialize() {
        if this.started {
            return
        }

        this.started := true

        this.hotkeys.Register("*Left", ObjBindMethod(this, "HandleDown", "Left"))
        this.hotkeys.Register("*Left Up", ObjBindMethod(this, "HandleUp", "Left"))
        this.hotkeys.Register("*Right", ObjBindMethod(this, "HandleDown", "Right"))
        this.hotkeys.Register("*Right Up", ObjBindMethod(this, "HandleUp", "Right"))
        this.hotkeys.Register("*Up", ObjBindMethod(this, "HandleDown", "Up"))
        this.hotkeys.Register("*Up Up", ObjBindMethod(this, "HandleUp", "Up"))
        this.hotkeys.Register("*Down", ObjBindMethod(this, "HandleDown", "Down"))
        this.hotkeys.Register("*Down Up", ObjBindMethod(this, "HandleUp", "Down"))
    }

    HandleDown(direction, *) {
        this.pressed[direction] := true
        this.EnsureLoop()
    }

    HandleUp(direction, *) {
        this.pressed[direction] := false
        if !this.AnyPressed() {
            this.timers.Remove(this.timerName)
        }
    }

    EnsureLoop() {
        if this.timers.Has(this.timerName) {
            return
        }
        this.timers.Add(this.timerName, 15, ObjBindMethod(this, "Tick"))
    }

    Tick() {
        if !this.AnyPressed() {
            this.timers.Remove(this.timerName)
            return
        }

        if !this.scene.Is("normal") {
            return
        }

        deltaX := 0
        deltaY := 0

        if this.pressed["Left"] {
            deltaX -= 20
        }
        if this.pressed["Right"] {
            deltaX += 20
        }
        if this.pressed["Up"] {
            deltaY -= 20
        }
        if this.pressed["Down"] {
            deltaY += 20
        }

        if (deltaX = 0 && deltaY = 0) {
            return
        }

        this.input.MouseMoveRelative(deltaX, deltaY)
    }

    AnyPressed() {
        for _name, pressed in this.pressed {
            if pressed {
                return true
            }
        }
        return false
    }
}
