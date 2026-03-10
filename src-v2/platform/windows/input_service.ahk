class InputService {
    __New(logger := "") {
        this.logger := logger
        SendMode("Event")
        SetKeyDelay(0, 20)
        SetMouseDelay(0, 20)
    }

    KeyDown(keyName) {
        SendEvent("{" keyName " down}")
        this.Debug("KeyDown => " keyName)
    }

    KeyUp(keyName) {
        SendEvent("{" keyName " up}")
        this.Debug("KeyUp => " keyName)
    }

    KeyPress(keyName, holdMs := 30) {
        this.KeyDown(keyName)
        Sleep(holdMs)
        this.KeyUp(keyName)
    }

    Click(buttonName := "Left") {
        Click(buttonName)
        this.Debug("Click => " buttonName)
    }

    MouseMoveRelative(deltaX, deltaY, speed := 0) {
        MouseMove(deltaX, deltaY, speed, "R")
        this.Debug(Format("MouseMoveRelative => dx={1}, dy={2}", deltaX, deltaY))
    }

    Debug(message) {
        if IsObject(this.logger) {
            this.logger.Debug(message)
        }
    }
}
