class HudService {
    __New(timers, logger := "") {
        this.timers := timers
        this.logger := logger
        this.baseId := 20
    }

    Show(slot, message, timeoutMs := 2000) {
        x := 40
        y := 40 + ((slot - 1) * 28)
        id := this.baseId + slot

        ToolTip(message, x, y, id)
        this.timers.Once(
            Format("hud/{1}", slot),
            timeoutMs,
            ObjBindMethod(this, "Hide", slot)
        )

        if IsObject(this.logger) {
            this.logger.Debug(Format("HUD[{1}] => {2}", slot, message))
        }
    }

    Hide(slot) {
        ToolTip(, , , this.baseId + slot)
    }

    HideAll() {
        loop 5 {
            this.Hide(A_Index)
        }
    }
}
