class CaptureService {
    __New(window, logger := "") {
        this.window := window
        this.logger := logger
        this.token := 0
        this.bitmap := 0
        this.lastRefreshAt := 0
    }

    Start() {
        if this.token {
            return
        }

        this.token := Gdip_Startup()
        if IsObject(this.logger) {
            this.logger.Info("Capture service started")
        }
    }

    Stop() {
        this.DisposeBitmap()
        if this.token {
            Gdip_Shutdown(this.token)
            this.token := 0
        }
    }

    Refresh() {
        if !this.token {
            this.Start()
        }

        if !this.window.Exists() || !this.window.IsActive() {
            this.DisposeBitmap()
            return false
        }

        hwnd := this.window.GetId()
        if !hwnd {
            this.DisposeBitmap()
            return false
        }

        bitmap := Gdip_BitmapFromHWND(hwnd)
        if !bitmap {
            return false
        }

        this.DisposeBitmap()
        this.bitmap := bitmap
        this.lastRefreshAt := A_TickCount
        return true
    }

    HasBitmap() {
        return !!this.bitmap
    }

    GetColor(point) {
        if !this.bitmap {
            return -1
        }

        x := point["x"]
        y := point["y"]

        argb := Gdip_GetPixel(this.bitmap, x, y)
        if (argb < 0) {
            return -1
        }

        return argb - 0xFF000000
    }

    DisposeBitmap() {
        if this.bitmap {
            Gdip_DisposeImage(this.bitmap)
            this.bitmap := 0
        }
    }
}
