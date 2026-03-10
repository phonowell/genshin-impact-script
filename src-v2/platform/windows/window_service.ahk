class WindowService {
    __New(config, logger := "") {
        this.config := config
        this.logger := logger
    }

    GetProcessName() {
        return this.config.Get("basic", "process", "")
    }

    GetCriteria() {
        processName := this.GetProcessName()
        if (processName = "") {
            return ""
        }
        return "ahk_exe " processName
    }

    Exists() {
        criteria := this.GetCriteria()
        return (criteria != "") && !!WinExist(criteria)
    }

    GetId() {
        criteria := this.GetCriteria()
        if (criteria = "") {
            return 0
        }
        return WinExist(criteria)
    }

    IsActive() {
        criteria := this.GetCriteria()
        if (criteria = "") {
            return false
        }
        return !!WinActive(criteria)
    }

    Activate() {
        criteria := this.GetCriteria()
        if (criteria = "") {
            return false
        }
        WinActivate(criteria)
        return true
    }

    Focus() {
        return this.Activate()
    }

    Close() {
        criteria := this.GetCriteria()
        if (criteria = "") {
            return false
        }
        WinClose(criteria)
        return true
    }

    Minimize() {
        criteria := this.GetCriteria()
        if (criteria = "") {
            return false
        }
        WinMinimize(criteria)
        return true
    }

    Move(left, top, width, height) {
        criteria := this.GetCriteria()
        if (criteria = "") {
            return false
        }

        try {
            WinMove(left, top, width, height, criteria)
            return true
        } catch {
            return false
        }
    }

    GetBounds() {
        id := this.GetId()
        if !id {
            return Map("x", 0, "y", 0, "width", 0, "height", 0)
        }

        WinGetPos(&x, &y, &width, &height, id)
        return Map("x", x, "y", y, "width", width, "height", height)
    }

    IsFullscreen() {
        bounds := this.GetBounds()
        return (
            bounds["x"] = 0
            && bounds["y"] = 0
            && Abs(bounds["width"] - A_ScreenWidth) <= 2
            && Abs(bounds["height"] - A_ScreenHeight) <= 2
        )
    }

    GetTaskbarBounds() {
        try {
            WinGetPos(&x, &y, &width, &height, "ahk_class Shell_TrayWnd")
            return Map("x", x, "y", y, "width", width, "height", height)
        } catch {
            return Map("x", 0, "y", 0, "width", 0, "height", 0)
        }
    }

    WaitForExist(timeoutMs := 5000, pollMs := 200) {
        startedAt := A_TickCount
        while ((A_TickCount - startedAt) < timeoutMs) {
            if this.Exists() {
                return true
            }
            Sleep(pollMs)
        }
        return false
    }

    GetProcessPath() {
        criteria := this.GetCriteria()
        if (criteria = "") {
            return ""
        }

        try return WinGetProcessPath(criteria)
        catch {
            return ""
        }
    }

    LaunchConfiguredProcess() {
        path := this.config.Get("basic", "path", "")
        arguments := this.config.Get("basic", "arguments", "")

        if (path = "") {
            return false
        }

        command := path
        if (arguments != "") {
            command .= " " arguments
        }

        try {
            Run(command)
            if IsObject(this.logger) {
                this.logger.Info("Launch requested for configured process")
            }
            return true
        } catch {
            if IsObject(this.logger) {
                this.logger.Warn("Failed to launch configured process")
            }
            return false
        }
    }
}
