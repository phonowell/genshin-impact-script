class ColorService {
    __New(window, capture, logger := "") {
        this.window := window
        this.capture := capture
        this.logger := logger

        CoordMode("Pixel", "Client")
        CoordMode("Mouse", "Client")
    }

    GetColor(point) {
        p := this.ResolvePoint(point)
        if this.capture.HasBitmap() {
            color := this.capture.GetColor(p)
            if (color >= 0) {
                return color
            }
        }

        try {
            return PixelGetColor(p["x"], p["y"], "RGB")
        } catch {
            return -1
        }
    }

    FindColor(color, area, step := 2) {
        a := this.ResolveArea(area)
        y := a["y1"]
        while (y <= a["y2"]) {
            x := a["x1"]
            while (x <= a["x2"]) {
                if (this.GetColor([x, y]) = color) {
                    return [x, y, color]
                }
                x += step
            }
            y += step
        }
        return false
    }

    FindAnyColor(colors, area, step := 2) {
        if !IsObject(colors) {
            colors := [colors]
        }

        for color in colors {
            result := this.FindColor(color, area, step)
            if result {
                return result
            }
        }

        return false
    }

    FindAllColors(colors, area, step := 2) {
        if !IsObject(colors) {
            colors := [colors]
        }

        for color in colors {
            if !this.FindColor(color, area, step) {
                return false
            }
        }

        return true
    }

    ResolvePoint(point) {
        if !IsObject(point) || point.Length < 2 {
            throw Error("Invalid point")
        }

        return Map(
            "x", this.ResolveX(point[1]),
            "y", this.ResolveY(point[2])
        )
    }

    ResolveArea(area) {
        if !IsObject(area) {
            throw Error("Invalid area")
        }

        if (area.Length >= 4) {
            return Map(
                "x1", this.ResolveX(area[1]),
                "y1", this.ResolveY(area[2]),
                "x2", this.ResolveX(area[3]),
                "y2", this.ResolveY(area[4])
            )
        }

        if (area.Length >= 2) {
            p1 := area[1]
            p2 := area[2]
            return Map(
                "x1", this.ResolveX(p1[1]),
                "y1", this.ResolveY(p1[2]),
                "x2", this.ResolveX(p2[1]),
                "y2", this.ResolveY(p2[2])
            )
        }

        throw Error("Invalid area")
    }

    ResolveX(value) {
        if IsNumber(value) {
            return value + 0
        }

        width := this.window.GetBounds()["width"]
        raw := StrReplace(value, "%", "")
        return Round(width * (raw + 0) * 0.01)
    }

    ResolveY(value) {
        if IsNumber(value) {
            return value + 0
        }

        height := this.window.GetBounds()["height"]
        raw := StrReplace(value, "%", "")
        return Round(height * (raw + 0) * 0.01)
    }
}
