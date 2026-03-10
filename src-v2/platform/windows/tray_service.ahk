class TrayService {
    __New(rootDir, logger := "") {
        this.rootDir := rootDir
        this.logger := logger
        this.app := ""
    }

    Initialize(app) {
        this.app := app

        A_IconTip := "GIS AHK v2"
        A_TrayMenu.Delete()
        A_TrayMenu.Add("Open config", ObjBindMethod(this, "OpenConfig"))
        A_TrayMenu.Add("Reload", ObjBindMethod(this, "ReloadScript"))
        A_TrayMenu.Add()
        A_TrayMenu.Add("Exit", ObjBindMethod(this, "ExitScript"))

        if IsObject(this.logger) {
            this.logger.Debug("Tray initialized")
        }
    }

    OpenConfig(*) {
        Run(this.rootDir "\data\config.ini")
    }

    ReloadScript(*) {
        Reload()
    }

    ExitScript(*) {
        if IsObject(this.app) {
            this.app.Stop(0)
            return
        }
        ExitApp(0)
    }
}
