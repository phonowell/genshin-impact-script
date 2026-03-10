class ConfigStore {
    __New(path, logger := "") {
        this.path := path
        this.logger := logger
        this.defaults := Map()
        this.values := Map()
        this.SeedDefaults()
    }

    SeedDefaults() {
        this.defaults["basic"] := Map(
            "arguments", "",
            "path", "",
            "process", ""
        )

        this.defaults["better-pickup"] := Map(
            "enable", "1",
            "use-auto-gadget", "0",
            "use-fast-pickup", "1",
            "use-quick-skip", "1"
        )

        this.defaults["misc"] := Map(
            "use-beep", "1",
            "use-better-jump", "0",
            "use-controller", "0",
            "use-debug-mode", "0",
            "use-mute", "1",
            "use-skill-timer", "0",
            "use-tactic", "0"
        )
    }

    Load() {
        if !FileExist(this.path) {
            throw Error("Config file not found: " this.path)
        }

        for section, defaults in this.defaults {
            if !this.values.Has(section) {
                this.values[section] := Map()
            }

            for key, fallback in defaults {
                this.values[section][key] := IniRead(this.path, section, key, fallback)
            }
        }

        if IsObject(this.logger) {
            this.logger.Debug("Config loaded from " this.path)
        }

        return this
    }

    Get(section, key, defaultValue := "") {
        if this.values.Has(section) && this.values[section].Has(key) {
            return this.values[section][key]
        }

        return IniRead(this.path, section, key, defaultValue)
    }

    GetBool(section, key, defaultValue := false) {
        rawDefault := defaultValue ? "1" : "0"
        value := this.Get(section, key, rawDefault)
        return value = "1"
    }

    Set(section, key, value) {
        if !this.values.Has(section) {
            this.values[section] := Map()
        }

        this.values[section][key] := value
        IniWrite(value, this.path, section, key)
        return value
    }
}
