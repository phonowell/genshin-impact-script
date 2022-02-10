do ->

  Config.data.gdip = true
  Config.data.weakNetwork = false
  Config.data.betterJump = true
  Config.data.fastPickup = true
  Config.data.quickEvent = true
  Config.data.skillTimer = true

  Timer.add 1e3, ->

    n = 20220216
    if A_YYYY * 1e4 + A_MM * 1e2 + A_DD > n
      $.exit()
      return
    console.log "trial/end: #{n}"

    unless Config.data.isDebug
      $.exit()
      return

    unless Picker.isAuto then Picker.toggle()
    Config.data.isFrozen = true