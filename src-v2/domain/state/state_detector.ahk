class StateDetector {
    __New(colorService, sceneDetector, stateRules, events, logger := "") {
        this.color := colorService
        this.scene := sceneDetector
        this.rules := stateRules
        this.events := events
        this.logger := logger
        this.flags := Map()
    }

    Replace(flagNames, source := "manual") {
        nextFlags := Map()
        changed := false

        if IsObject(flagNames) {
            for item in flagNames {
                nextFlags[item] := true
            }
        }

        changed := this.HasChanged(nextFlags)
        this.flags := nextFlags

        if !changed {
            return false
        }

        if IsObject(this.logger) {
            names := this.GetList()
            text := "-"
            if (names.Length > 0) {
                text := ""
                for index, item in names {
                    if (index > 1) {
                        text .= ", "
                    }
                    text .= item
                }
            }
            this.logger.Info("State flags => " text)
        }

        this.events.Emit("state:changed", this.GetList(), source)
        return true
    }

    Set(name, enabled := true, source := "manual") {
        if (name = "") {
            throw Error("State name is required")
        }

        if enabled {
            this.flags[name] := true
        } else if this.flags.Has(name) {
            this.flags.Delete(name)
        }

        this.events.Emit("state:changed", this.GetList(), source)
    }

    Detect() {
        next := []

        if this.scene.Is("normal") {
            if this.CheckIsSingle() {
                next.Push("single")
            }

            if this.CheckIsDomain() {
                next.Push("domain")
            }

            if this.CheckElement("cryo") {
                next.Push("cryo")
            }

            if this.CheckElement("hydro") {
                next.Push("hydro")
            }

            if this.CheckIsFrozen(next) {
                next.Push("frozen")
            }

            if this.CheckIsFree() {
                next.Push("free")
                if this.CheckIsReady() {
                    next.Push("ready")
                }
            }
        }

        this.Replace(next, "detect")
        return next
    }

    Has(name) {
        return this.flags.Has(name)
    }

    GetList() {
        list := []
        for name, enabled in this.flags {
            if enabled {
                list.Push(name)
            }
        }
        return list
    }

    CheckIsDomain() {
        return this.color.FindAllColors([0x38425C, 0xFFFFFF], [["1%", "9%"], ["3%", "13%"]])
    }

    CheckIsFree() {
        return this.color.FindAllColors([0xFFFFFF, 0x323232], [["94%", "80%"], ["95%", "82%"]])
    }

    CheckIsReady() {
        return !!this.color.FindAnyColor([0x96D722, 0xFF6666], [["88%", "25%"], ["89%", "53%"]])
    }

    CheckIsSingle() {
        area := [["18%", "2%"], ["20%", "6%"]]
        if !this.color.FindAnyColor(0xFFFFFF, area) {
            return false
        }
        return !this.color.FindAnyColor([0x006699, 0x408000], area)
    }

    CheckElement(name) {
        colors := this.rules.GetElementColors(name)
        if !IsObject(colors) || colors.Length = 0 {
            return false
        }
        return this.color.FindAllColors(colors, [["42%", "88%"], ["58%", "91%"]])
    }

    CheckIsFrozen(flags) {
        isCryo := false
        isHydro := false

        for flag in flags {
            if (flag = "cryo") {
                isCryo := true
            } else if (flag = "hydro") {
                isHydro := true
            }
        }

        if !(isCryo || isHydro) {
            return false
        }

        if !this.color.FindAllColors(0xF05C4A, [["73%", "48%"], ["75%", "52%"]]) {
            return false
        }

        return this.color.FindAllColors([0xFFFFFF, 0x323232], [["72%", "53%"], ["75%", "56%"]])
    }

    HasChanged(nextFlags) {
        currentCount := 0
        nextCount := 0

        for _name, enabled in this.flags {
            if enabled {
                currentCount += 1
            }
        }

        for _name, enabled in nextFlags {
            if enabled {
                nextCount += 1
            }
        }

        if (currentCount != nextCount) {
            return true
        }

        for name, enabled in nextFlags {
            if enabled && !this.flags.Has(name) {
                return true
            }
        }

        return false
    }
}
