#Requires AutoHotkey v2.0

class FakeWindowService {
    __New() {
        this.exists := true
        this.active := true
        this.fullscreen := false
        this.bounds := Map("x", 0, "y", 0, "width", 1600, "height", 900)
        this.moves := []
    }

    Exists() {
        return this.exists
    }

    IsActive() {
        return this.active
    }

    IsFullscreen() {
        return this.fullscreen
    }

    GetBounds() {
        return this.bounds
    }

    GetId() {
        return this.exists ? 123 : 0
    }

    GetCriteria() {
        return "ahk_exe fake.exe"
    }

    Move(left, top, width, height) {
        this.moves.Push([left, top, width, height])
        this.bounds := Map("x", left, "y", top, "width", width, "height", height)
        return true
    }

    GetTaskbarBounds() {
        return Map("x", 0, "y", 860, "width", 1600, "height", 40)
    }
}
