# @ts-check

class CameraG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/camera').CameraG['count'] ###
    @count = 0
    ###* @type import('./type/camera').CameraG['isWatching'] ###
    @isWatching = false
    ###* @type import('./type/camera').CameraG['listKey'] ###
    @listKey = ['left', 'right', 'up', 'down']

  ###* @type import('./type/camera'). CameraG['init'] ###
  init: ->

    Scene.useEffect =>

      for key in @listKey
        @registerEvent 'press', key

      @on 'press:start', =>
        unless @count then @emit 'move:start'
        if @count >= 4 then return
        @count++

      @on 'press:end', =>
        if @count == 1 then @emit 'move:end'
        if @count <= 0 then return
        @count--

      @on 'move:start', @watch
      @on 'move:end', @watch

      return =>
        for key in @listKey
          @unregisterEvent 'press', key
        @off 'press:start'
        @off 'press:end'
        @off 'move:start'
        @off 'move:end'

    , ['normal']

  ###* @type import('./type/camera').CameraG['move'] ###
  move: ->

    unless Scene.is 'normal' then return

    if @isPressed['left'] then x = -1
    else if @isPressed['right'] then x = 1
    else x = 0

    if @isPressed['up'] then y = -1
    else if @isPressed['down'] then y = 1
    else y = 0

    if x == 0 and y == 0 then return
    x *= 2
    y *= 2

    count = 0
    vMax = 10
    while count < vMax
      count++
      Native 'DllCall("mouse_event", "UInt", 0x01, "UInt", x, "UInt", y)'
    return

  ###* @type import('./type/camera').CameraG['watch'] ###
  watch: ->

    interval = 15
    token = 'camera/watch'
    eventIdle = 'idle.camera'
    eventActivate = 'activate.camera'

    if @isWatching
      @isWatching = false
      Client.off eventIdle
      Client.off eventActivate
      Timer.remove token
      return

    @isWatching = true
    Client.on eventIdle, -> Timer.remove token
    Client.on eventActivate, => Timer.loop token, interval, @move
    Timer.loop token, interval, @move

# export
Camera = new CameraG()