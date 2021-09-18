# function

class PickerX

  isFound: false
  isPicking: false
  tsDetect: 0

  constructor: ->

    if Config.data.quickEvent then Client.on 'tick', @pick
    if Config.data.autoPickup then Client.on 'tick', @detect

    Player.on 'pick:start', =>
      $.press 'f'
      unless Config.data.fastPickup then return
      @isPicking = true

    Player.on 'pick:end', => @isPicking = false

  detect: ->

    if @isPicking then return
    unless Scene.name == 'normal' then return

    interval = 200
    if @isFound then interval = 100

    now = $.now()
    unless now - @tsDetect >= interval then return
    @tsDetect = now

    [x, y] = @find [57, 40], [59, 60], 0x323232
    unless x * y > 0
      @isFound = false
      return

    start = [
      Client.vw 61
      y - 1
    ]
    end = [
      Client.vw 63
      y + 1
    ]
    [x, y] = $.findColor 0xFFFFFF, start, end
    if x * y > 0
      @isFound = false
      return

    @isFound = true
    $.press 'f'
    $.click 'wheel-down'

  find: (start, end, color = 0xFFFFFF) ->
    [x, y] = $.findColor color, (Client.point start), Client.point end
    return [x, y]

  pick: ->
    unless @isPicking then return
    if @skip() then return
    unless Scene.name == 'normal' then return
    $.press 'f'
    $.click 'wheel-down'

  skip: ->

    unless Scene.name == 'event' then return false

    $.press 'f'

    point = ''
    for color in [0x806200, 0xFFCC32, 0xFFFFFF]
      [x, y] = @find [65, 40], [70, 80], color
      if x * y > 0
        point = [x, y]
        break

    unless point then return false

    $.move point
    $.click()
    return true

# execute
Picker = new PickerX()