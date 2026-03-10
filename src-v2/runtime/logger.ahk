class Logger {
    __New(logFilePath := "", debugMode := false) {
        this.logFilePath := logFilePath
        this.debugMode := debugMode
    }

    SetDebug(enabled) {
        this.debugMode := !!enabled
    }

    Debug(message) {
        if !this.debugMode {
            return
        }
        this.Write("DEBUG", message)
    }

    Info(message) {
        this.Write("INFO", message)
    }

    Warn(message) {
        this.Write("WARN", message)
    }

    Error(message) {
        this.Write("ERROR", message)
    }

    Write(level, message) {
        line := Format("[{1}] [{2}] {3}`n", FormatTime(, "yyyy-MM-dd HH:mm:ss"), level, message)
        OutputDebug(line)

        if (this.logFilePath = "") {
            return
        }

        try FileAppend(line, this.logFilePath, "UTF-8")
    }
}
