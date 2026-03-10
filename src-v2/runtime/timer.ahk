class TimerRegistry {
    __New() {
        this.entries := Map()
    }

    Add(name, periodMs, callback) {
        this.Remove(name)
        this.entries[name] := {
            callback: callback,
            period: periodMs,
        }
        SetTimer(callback, periodMs)
        return name
    }

    Once(name, delayMs, callback) {
        this.Remove(name)
        this.entries[name] := {
            callback: callback,
            period: -Abs(delayMs),
        }
        SetTimer(callback, -Abs(delayMs))
        return name
    }

    Remove(name) {
        if !this.entries.Has(name) {
            return false
        }

        entry := this.entries[name]
        SetTimer(entry["callback"], 0)
        this.entries.Delete(name)
        return true
    }

    Has(name) {
        return this.entries.Has(name)
    }

    Clear() {
        names := []
        for name, _entry in this.entries {
            names.Push(name)
        }
        for name in names {
            this.Remove(name)
        }
    }
}
