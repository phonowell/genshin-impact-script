do ->

  Config.set 'better-jump', true

  Config.set 'better-pickup', true
  Config.set 'better-pickup/use-fast-pickup', true
  Config.set 'better-pickup/use-quick-skip', true

  Config.set 'skill-timer', true

  Config.set 'sound/use-beep', true
  Config.set 'sound/use-mute-when-idle', true

  Timer.add 1e3, ->

    n = 20220501
    if A_YYYY * 1e4 + A_MM * 1e2 + A_DD > n
      $.exit()
      return
    console.log "trial/end: #{n}"

    unless Config.get 'debug'
      $.exit()
      return

    unless Picker.isAuto then Picker.toggle()
    Config.set 'debug/frozen', true