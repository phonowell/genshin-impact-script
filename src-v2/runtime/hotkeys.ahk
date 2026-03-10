class HotkeyRegistry {
    __New(logger := "") {
        this.logger := logger
        this.entries := Map()
        this.nextToken := 1
        this.enabled := false
    }

    Register(name, callback, options := "") {
        token := this.nextToken
        this.nextToken += 1

        this.entries[token] := {
            name: name,
            callback: callback,
            options: options,
        }

        if this.enabled {
            this.ApplyEntry(this.entries[token])
        }

        return token
    }

    Unregister(token) {
        if !this.entries.Has(token) {
            return false
        }

        entry := this.entries[token]
        try Hotkey(entry["name"], "Off")
        this.entries.Delete(token)
        return true
    }

    EnableAll() {
        for _token, entry in this.entries {
            this.ApplyEntry(entry)
        }
        this.enabled := true
    }

    DisableAll() {
        for _token, entry in this.entries {
            try Hotkey(entry["name"], "Off")
        }
        this.enabled := false
    }

    ApplyEntry(entry) {
        Hotkey(entry["name"], entry["callback"], entry["options"])
        if IsObject(this.logger) {
            this.logger.Debug("Registered hotkey: " entry["name"])
        }
    }
}
