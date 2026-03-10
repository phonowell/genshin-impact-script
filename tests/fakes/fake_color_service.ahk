#Requires AutoHotkey v2.0

class FakeColorService {
    __New() {
        this.findAllCallback := ObjBindMethod(this, "DefaultFindAll")
        this.findAnyCallback := ObjBindMethod(this, "DefaultFindAny")
        this.getColorCallback := ObjBindMethod(this, "DefaultGetColor")
    }

    SetFindAllCallback(callback) {
        this.findAllCallback := callback
    }

    SetFindAnyCallback(callback) {
        this.findAnyCallback := callback
    }

    SetGetColorCallback(callback) {
        this.getColorCallback := callback
    }

    FindAllColors(colors, area, step := 2) {
        return this.findAllCallback.Call(colors, area, step)
    }

    FindAnyColor(colors, area, step := 2) {
        return this.findAnyCallback.Call(colors, area, step)
    }

    GetColor(point) {
        return this.getColorCallback.Call(point)
    }

    DefaultFindAll(colors, area, step := 2) {
        return false
    }

    DefaultFindAny(colors, area, step := 2) {
        return false
    }

    DefaultGetColor(point) {
        return -1
    }
}
