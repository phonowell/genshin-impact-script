#Requires AutoHotkey v2.0

class FakeHud {
    __New() {
        this.messages := []
    }

    Show(slot, message, timeoutMs := 2000) {
        this.messages.Push(Format("{1}|{2}", slot, message))
    }
}
