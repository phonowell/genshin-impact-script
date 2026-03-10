#Requires AutoHotkey v2.0

class FakeHotkeys {
    __New() {
        this.entries := []
    }

    Register(name, callback, options := "") {
        this.entries.Push({
            name: name,
            callback: callback,
            options: options,
        })
        return this.entries.Length
    }
}
