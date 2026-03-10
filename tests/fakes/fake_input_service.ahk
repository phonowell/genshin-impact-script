#Requires AutoHotkey v2.0

class FakeInputService {
    __New() {
        this.events := []
    }

    KeyDown(keyName) {
        this.events.Push("down|" keyName)
    }

    KeyUp(keyName) {
        this.events.Push("up|" keyName)
    }

    MouseMoveRelative(deltaX, deltaY, speed := 0) {
        this.events.Push(Format("move|{1}|{2}", deltaX, deltaY))
    }
}
