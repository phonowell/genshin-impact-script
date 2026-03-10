class SceneDetector {
    __New(colorService, window, events, logger := "") {
        this.color := colorService
        this.window := window
        this.events := events
        this.logger := logger
        this.current := "unknown"
        this.previous := ""
        this.details := []
    }

    Get() {
        return this.current
    }

    GetList() {
        return this.details
    }

    Is(name) {
        if IsObject(name) {
            for item in name {
                if (item = this.current) {
                    return true
                }
            }
            return false
        }

        return this.current = name
    }

    SetDetails(names, source := "manual") {
        if !IsObject(names) || names.Length = 0 {
            names := ["unknown"]
        }

        name := names[1]
        changed := name != this.current || this.HasDetailsChanged(names)
        this.details := names

        if !changed {
            return false
        }

        this.previous := this.current
        this.current := name

        if IsObject(this.logger) {
            this.logger.Info(
                Format("Scene changed => prev={1}, next={2}, source={3}", this.previous, this.current, source)
            )
        }

        this.events.Emit("scene:changed", this.details, this.previous, source)
        return true
    }

    Detect() {
        if !this.window.Exists() || !this.window.IsActive() {
            this.SetDetails(["unknown"], "window")
            return this.details
        }

        list := this.Check()
        if !IsObject(list) || list.Length = 0 {
            list := ["unknown"]
        }

        this.SetDetails(list, "detect")
        return this.details
    }

    Check() {
        checks := [
            ObjBindMethod(this, "AboutLoading"),
            ObjBindMethod(this, "AboutMenu"),
            ObjBindMethod(this, "AboutHalfMenu"),
            ObjBindMethod(this, "AboutNormal"),
            ObjBindMethod(this, "AboutDialogue"),
            ObjBindMethod(this, "AboutMiniMenu")
        ]

        for check in checks {
            result := check.Call()
            if IsObject(result) && result.Length > 0 {
                return result
            }
        }

        return []
    }

    AboutDialogue() {
        if this.CheckIsDialogue() {
            return ["dialogue"]
        }
        return []
    }

    AboutHalfMenu() {
        if !this.CheckIsHalfMenu() {
            return []
        }

        result := ["half-menu"]
        if this.CheckIsChat() {
            result.Push("chat")
        }
        return result
    }

    AboutLoading() {
        return this.CheckIsLoading() ? ["loading"] : []
    }

    AboutMenu() {
        if !this.CheckIsMenu() {
            return []
        }

        result := ["menu"]
        if this.CheckIsMap() {
            result.Push("map")
        } else if this.CheckIsParty() {
            result.Push("party")
        } else if this.CheckIsPlaying() {
            result.Push("playing")
        }
        return result
    }

    AboutMiniMenu() {
        return this.CheckIsMiniMenu() ? ["mini-menu"] : []
    }

    AboutNormal() {
        return this.CheckIsNormal() ? ["normal"] : []
    }

    CheckIsChat() {
        return this.color.FindAllColors([0x3B4255, 0xECE5D8], [["58%", "2%"], ["60%", "6%"]])
    }

    CheckIsDialogue() {
        return this.color.FindAllColors(0xFFC300, [["45%", "79%"], ["55%", "82%"]])
    }

    CheckIsHalfMenu() {
        return this.color.FindAllColors([0x3B4255, 0xECE5D8], [["1%", "3%"], ["3%", "6%"]])
    }

    CheckIsLoading() {
        bounds := this.window.GetBounds()
        if (bounds["width"] <= 0) {
            return false
        }

        color := this.color.GetColor([bounds["width"] - 1, "50%"])
        return color = 0xFFFFFF || color = 0x000000 || color = 0x1C1C22
    }

    CheckIsMap() {
        return this.color.FindAllColors(0xEDE5DA, [["1%", "38%"], ["2%", "40%"]])
    }

    CheckIsMenu() {
        return this.color.FindAllColors([0x3B4255, 0xECE5D8], [["95%", "3%"], ["97%", "6%"]])
    }

    CheckIsMiniMenu() {
        if !this.color.FindAllColors(0xECE5D8, [["97%", "1%"], ["98%", "5%"]]) {
            return false
        }
        return !!this.color.FindAnyColor([0x3D4555, 0xE2B42A], [["97%", "1%"], ["98%", "5%"]])
    }

    CheckIsNormal() {
        if this.color.FindAllColors(0xFFFFFF, [["2%", "17%"], ["4%", "21%"]]) {
            return true
        }
        return this.color.FindAllColors(0xFFFFFF, [["1%", "9%"], ["3%", "13%"]])
    }

    CheckIsParty() {
        return this.color.FindAllColors(0xFFFFFF, [["41%", "3%"], ["59%", "6%"]])
    }

    CheckIsPlaying() {
        return this.color.FindAllColors([0xFFFFFF, 0xFFE92C], [["9%", "2%"], ["11%", "6%"]])
    }

    Set(name, source := "manual") {
        if (name = "") {
            throw Error("Scene name is required")
        }

        return this.SetDetails([name], source)
    }

    Snapshot() {
        return Map(
            "current", this.current,
            "previous", this.previous,
            "details", this.details
        )
    }

    HasDetailsChanged(nextDetails) {
        if (this.details.Length != nextDetails.Length) {
            return true
        }

        loop nextDetails.Length {
            if (this.details[A_Index] != nextDetails[A_Index]) {
                return true
            }
        }

        return false
    }
}
