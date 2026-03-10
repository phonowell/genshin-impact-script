class StateRules {
    __New(path, logger := "") {
        this.path := path
        this.logger := logger
        this.elementColors := Map()
    }

    Load() {
        if !FileExist(this.path) {
            throw Error("State rules file not found: " this.path)
        }

        this.elementColors["cryo"] := [
            this.ReadHex("elements", "cryo_primary"),
            this.ReadHex("elements", "cryo_secondary")
        ]

        this.elementColors["hydro"] := [
            this.ReadHex("elements", "hydro_primary"),
            this.ReadHex("elements", "hydro_secondary")
        ]

        if IsObject(this.logger) {
            this.logger.Debug("State rules loaded from " this.path)
        }

        return this
    }

    GetElementColors(name) {
        if !this.elementColors.Has(name) {
            return []
        }
        return this.elementColors[name]
    }

    ReadHex(section, key) {
        value := IniRead(this.path, section, key, "")
        if (value = "") {
            throw Error(Format("Missing state rule: [{1}] {2}", section, key))
        }
        return value + 0
    }
}
