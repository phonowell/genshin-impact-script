#Requires AutoHotkey v2.0

class FakeTimers {
    __New() {
        this.entries := Map()
    }

    Add(name, periodMs, callback) {
        this.entries[name] := {
            period: periodMs,
            callback: callback,
        }
        return name
    }

    Once(name, periodMs, callback) {
        this.entries[name] := {
            period: periodMs,
            callback: callback,
        }
        return name
    }

    Remove(name) {
        if this.entries.Has(name) {
            this.entries.Delete(name)
            return true
        }
        return false
    }

    Has(name) {
        return this.entries.Has(name)
    }
}
