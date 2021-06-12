for key in recorder.listHotkey
  player.on "hotkey-#{key}:start", ->
    unless statusChecker.checkIsActive()
      return
    recorder.replay key