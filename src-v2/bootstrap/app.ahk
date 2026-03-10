class GenshinApp {
    __New(rootDir, services) {
        this.rootDir := rootDir
        this.services := services
        this.started := false
    }

    Start() {
        if (this.started) {
            return
        }

        this.started := true

        config := this.services.Get("config")
        logger := this.services.Get("logger")
        tray := this.services.Get("tray")
        window := this.services.Get("window")
        capture := this.services.Get("capture")
        scene := this.services.Get("scene")
        state := this.services.Get("state")
        timers := this.services.Get("timers")
        autoForward := this.services.Get("feature:auto-forward")
        cameraControl := this.services.Get("feature:camera-control")
        windowPosition := this.services.Get("feature:window-position")

        config.Load()
        logger.SetDebug(config.GetBool("misc", "use-debug-mode", false))

        tray.Initialize(this)
        this.RegisterCoreHotkeys()
        autoForward.Initialize()
        cameraControl.Initialize()
        windowPosition.Initialize()

        logger.Info("GIS AHK v2 skeleton started")
        logger.Info("Config path: " config.path)
        logger.Debug("Initial scene: " scene.Get())
        logger.Debug("Initial state count: " state.GetList().Length)
        logger.Info("Platform ready: capture")
        logger.Info("Feature ready: auto-forward")
        logger.Info("Feature ready: camera-control")
        logger.Info("Feature ready: window-position")

        if (window.Exists()) {
            logger.Info("Target window detected: " window.GetCriteria())
        } else {
            logger.Info("Target window not detected yet")
            window.LaunchConfiguredProcess()
        }

        capture.Start()
        timers.Add("platform/capture", 120, ObjBindMethod(capture, "Refresh"))
        timers.Add("detectors/scene", 300, ObjBindMethod(scene, "Detect"))
        timers.Add("detectors/state", 350, ObjBindMethod(state, "Detect"))
    }

    RegisterCoreHotkeys() {
        hotkeys := this.services.Get("hotkeys")

        hotkeys.Register("!F4", ObjBindMethod(this, "HandleShutdown"))
        hotkeys.Register("^F5", ObjBindMethod(this, "HandleReload"))
        hotkeys.Register("^!F12", ObjBindMethod(this, "HandleSmoke"))
        hotkeys.EnableAll()
    }

    HandleReload(*) {
        this.services.Get("logger").Info("Reload requested")
        Reload()
    }

    HandleSmoke(*) {
        logger := this.services.Get("logger")
        config := this.services.Get("config")
        window := this.services.Get("window")
        scene := this.services.Get("scene")
        state := this.services.Get("state")
        capture := this.services.Get("capture")
        bounds := window.GetBounds()

        logger.Info("Smoke check")
        logger.Info("Process: " config.Get("basic", "process", ""))
        logger.Info("Scene: " scene.Get())
        logger.Info("Scene details: " scene.GetList().Length)
        logger.Info("State flags: " state.GetList().Length)
        logger.Info("Capture bitmap: " (capture.HasBitmap() ? 1 : 0))
        logger.Info(
            Format(
                "Window state => exists={1}, active={2}, fullscreen={3}, bounds={4},{5},{6},{7}",
                window.Exists() ? 1 : 0,
                window.IsActive() ? 1 : 0,
                window.IsFullscreen() ? 1 : 0,
                bounds["x"],
                bounds["y"],
                bounds["width"],
                bounds["height"]
            )
        )
    }

    HandleShutdown(*) {
        this.Stop(0)
    }

    Stop(exitCode := 0) {
        this.services.Get("logger").Info("Shutdown requested")
        this.services.Get("hotkeys").DisableAll()
        this.services.Get("timers").Clear()
        this.services.Get("hud").HideAll()
        this.services.Get("capture").Stop()
        ExitApp(exitCode)
    }

    HandleExit(exitReason, exitCode) {
        try this.services.Get("logger").Info(
            Format("OnExit => reason={1}, code={2}", exitReason, exitCode)
        )
    }
}
