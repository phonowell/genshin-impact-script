#Requires AutoHotkey v2.0

class FakeLogger {
    __New() {
        this.messages := []
    }

    Debug(message) {
        this.messages.Push("DEBUG|" message)
    }

    Info(message) {
        this.messages.Push("INFO|" message)
    }

    Warn(message) {
        this.messages.Push("WARN|" message)
    }

    Error(message) {
        this.messages.Push("ERROR|" message)
    }
}
