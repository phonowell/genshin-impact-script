class AutoForwardFeature {
    __New(hotkeys, input, scene, state, events, hud, logger := "") {
        this.hotkeys := hotkeys
        this.input := input
        this.scene := scene
        this.state := state
        this.events := events
        this.hud := hud
        this.logger := logger
        this.enabled := false
        this.started := false
        this.tokens := []
    }

    Initialize() {
        if this.started {
            return
        }

        this.started := true
        this.tokens.Push(this.hotkeys.Register("!w", ObjBindMethod(this, "HandleToggle")))
        this.tokens.Push(this.hotkeys.Register("~w", ObjBindMethod(this, "HandleManualStop")))
        this.tokens.Push(this.hotkeys.Register("~s", ObjBindMethod(this, "HandleManualStop")))
        this.events.On("scene:changed", ObjBindMethod(this, "HandleSceneChanged"))
        this.events.On("state:changed", ObjBindMethod(this, "HandleStateChanged"))
    }

    HandleToggle(*) {
        if this.enabled {
            this.Stop("toggle")
            return
        }

        if !this.scene.Is("normal") {
            this.Log("Auto forward blocked: scene is not normal")
            return
        }

        if this.state.Has("domain") {
            this.Log("Auto forward blocked: domain state")
            return
        }

        this.Start("toggle")
    }

    HandleManualStop(*) {
        if this.enabled {
            this.Stop("manual")
        }
    }

    HandleSceneChanged(sceneList, _previous, source) {
        if !this.enabled {
            return
        }

        if !this.scene.Is("normal") {
            this.Stop("scene:" source)
        }
    }

    HandleStateChanged(_stateList, source) {
        if !this.enabled {
            return
        }

        if this.state.Has("domain") {
            this.Stop("state:" source)
        }
    }

    Start(source := "manual") {
        if this.enabled {
            return
        }

        this.enabled := true
        this.input.KeyDown("w")
        this.hud.Show(1, "auto forward [ON]")
        this.Log("Auto forward [ON] via " source)
    }

    Stop(source := "manual") {
        if !this.enabled {
            return
        }

        this.enabled := false
        this.input.KeyUp("w")
        this.hud.Show(1, "auto forward [OFF]")
        this.Log("Auto forward [OFF] via " source)
    }

    Log(message) {
        if IsObject(this.logger) {
            this.logger.Info(message)
        }
    }
}
