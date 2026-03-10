class WindowPositionFeature {
    __New(hotkeys, window, hud, logger := "") {
        this.hotkeys := hotkeys
        this.window := window
        this.hud := hud
        this.logger := logger
        this.started := false
        this.position := [2, 2]
    }

    Initialize() {
        if this.started {
            return
        }

        this.started := true
        this.hotkeys.Register("#Left", ObjBindMethod(this, "HandleMoveLeft"))
        this.hotkeys.Register("#Right", ObjBindMethod(this, "HandleMoveRight"))
        this.hotkeys.Register("#Up", ObjBindMethod(this, "HandleMoveUp"))
        this.hotkeys.Register("#Down", ObjBindMethod(this, "HandleMoveDown"))
    }

    HandleMoveLeft(*) {
        this.MoveBy(-1, 0)
    }

    HandleMoveRight(*) {
        this.MoveBy(1, 0)
    }

    HandleMoveUp(*) {
        this.MoveBy(0, -1)
    }

    HandleMoveDown(*) {
        this.MoveBy(0, 1)
    }

    MoveBy(deltaX, deltaY) {
        if !this.window.Exists() {
            this.Log("Window move skipped: target window missing")
            return
        }

        if this.window.IsFullscreen() {
            this.Log("Window move skipped: fullscreen")
            return
        }

        x := this.position[1] + deltaX
        y := this.position[2] + deltaY

        if (x < 0) {
            x := 0
        } else if (x > 2) {
            x := 2
        }

        if (y < 0) {
            y := 0
        } else if (y > 2) {
            y := 2
        }

        this.position := [x, y]
        this.ApplyPosition()
    }

    ApplyPosition() {
        bounds := this.window.GetBounds()
        if (bounds["width"] <= 0 || bounds["height"] <= 0) {
            return
        }

        width := Round(bounds["width"] / 80) * 80
        height := Round(width / 16 * 9)

        slotX := this.position[1]
        slotY := this.position[2]

        left := 0
        if (slotX = 1) {
            left := Round((A_ScreenWidth - width) * 0.5)
        } else if (slotX = 2) {
            left := A_ScreenWidth - width
        }

        top := 0
        if (slotY = 1) {
            top := Round((A_ScreenHeight - height) * 0.5)
        } else if (slotY = 2) {
            taskbarHeight := this.window.GetTaskbarBounds()["height"]
            top := A_ScreenHeight - height - taskbarHeight
        }

        if this.window.Move(left, top, width, height) {
            this.hud.Show(2, Format("window slot [{1},{2}]", slotX, slotY))
            this.Log(Format("Window moved => x={1}, y={2}", slotX, slotY))
        }
    }

    Log(message) {
        if IsObject(this.logger) {
            this.logger.Info(message)
        }
    }
}
