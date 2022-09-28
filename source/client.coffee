# @ts-check

class ClientG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/client').ClientG['height'] ###
    @height = 0
    ###* @type import('./type/client').ClientG['isActive'] ###
    @isActive = false
    ###* @type import('./type/client').ClientG['isFullScreen'] ###
    @isFullScreen = false
    ###* @type import('./type/client').ClientG['isSuspended'] ###
    @isSuspended = false
    ###* @type import('./type/client').ClientG['position'] ###
    @position = [1, 1]
    ###* @type import('./type/client').ClientG['width'] ###
    @width = 0
    ###* @type import('./type/client').ClientG['window'] ###
    @window = $.window $.toString Config.get 'basic/process'
    ###* @type import('./type/client').ClientG['x'] ###
    @x = 0
    ###* @type import('./type/client').ClientG['y'] ###
    @y = 0

    Native 'Menu, Tray, Icon, on.ico,, 1'

    unless @window.isExists()
      if Config.get 'basic/path'
        try $.open $.join [
          $.toString Config.get 'basic/path'
          $.toString Config.get 'basic/arguments'
        ], ' '
        catch then $.alert Dictionary.get 'invalid_path'

    @window.wait @init

  ###* @type import('./type/client').ClientG['getState'] ###
  getState: ->
    {x, y, width, height} = @window.getBounds()
    [@x, @y] = [x, y]
    [@width, @height] = [width, height]
    @isFullScreen = @window.isFullScreen()
    return

  ###* @type import('./type/client').ClientG['getTaskBarBounds'] ###
  getTaskBarBounds: ->
    [x, y, w, h] = [0, 0, 0, 0]

    name = 'ahk_class Shell_TrayWnd'
    $.noop name
    Native 'WinGetPos, x, y, w, h, % name'

    return [x, y, w, h]

  ###* @type import('./type/client').ClientG['init'] ###
  init: ->

    Config.detectPath()
    @watch()

    @on 'leave', =>
      console.log 'client: leave'
      Native 'Menu, Tray, Icon, off.ico'
      @suspend true
      @window.setPriority 'low'
      @emit 'idle'

    @on 'enter', =>
      console.log 'client: enter'
      Native 'Menu, Tray, Icon, on.ico'
      @suspend false
      @window.setPriority 'normal'
      @getState()
      @setStyle()
      Timer.add 1e3, @getState
      @emit 'activate'

    @on 'activate', =>
      @isActive = true
      console.log 'client: activate'
      unless @isMouseInside() then $.move [@width * 0.5, @height * 0.5]

    @on 'idle', =>
      @isActive = false
      console.log 'client: idle'

    $.on 'alt + f4', => Sound.beep 2, =>
      @reset()
      if Config.get 'basic/path'
        @window.minimize()
        @window.close()
        Sound.unmute()
      $.exit()

    $.on 'ctrl + f5', -> Sound.beep 3, $.reload

    $.on 'alt + enter', =>
      $.press 'alt + enter'
      @getState()
      @setStyle()

    for direction in ['left', 'right', 'up', 'down']
      $.on "win + #{direction}", =>

        if @isFullScreen then return
        [x, y] = @position

        switch direction
          when 'left' then x -= 1
          when 'right' then x += 1
          when 'up' then y -= 1
          when 'down' then y += 1

        if x < 0 then x = 0
        if x > 2 then x = 2
        if y < 0 then y = 0
        if y > 2 then y = 2

        @position = [x, y]
        @setPosition()

    return

  ###* @type import('./type/client').ClientG['isMouseInside'] ###
  isMouseInside: ->
    [x, y] = $.getPosition()
    if x < 0 then return false
    if x >= @width then return false
    if y < 0 then return false
    if y >= @height then return false
    return true

  ###* @type import('./type/client').ClientG['reset'] ###
  reset: ->
    @window.setPriority 'normal'
    Timer.reset()
    return

  ###* @type import('./type/client').ClientG['setPosition'] ###
  setPosition: ->

    [x, y] = @position
    width = ($.Math.round @width / 80) * 80
    height = $.Math.round width / 16 * 9

    left = 0
    switch x
      when 0 then left = 0
      when 1 then left = (A_ScreenWidth - width) * 0.5
      when 2 then left = A_ScreenWidth - width

    top = 0
    switch y
      when 0 then top = 0
      when 1 then top = (A_ScreenHeight - height) * 0.5
      when 2
        [_l, _t, _w, h] = @getTaskBarBounds()
        top = A_ScreenHeight - height - h

    name = "ahk_exe #{Config.get 'basic/process'}"
    $.noop name, left, top, width, height
    Native 'WinMove, % name,, % left, % top, % width, % height'
    @getState()

  ###* @type import('./type/client').ClientG['setStyle'] ###
  setStyle: ->
    @window.setStyle -0x00040000 # border
    @window.setStyle -0x00C00000 # caption
    if @isFullScreen then return
    @setPosition()

  ###* @type import('./type/client').ClientG['suspend'] ###
  suspend: (isSuspended) ->

    if isSuspended
      if @isSuspended then return
      @isSuspended = true
      $.suspend true
      return

    unless isSuspended
      unless @isSuspended then return
      @isSuspended = false
      $.suspend false
      return

  ###* @type import('./type/client').ClientG['update'] ###
  update: ->

    unless @window.isActive()
      unless @isSuspended then @emit 'leave'
      return

    if @isSuspended then @emit 'enter'

    # blur
    unless @isActive then return
    unless Config.get 'idle/use-mouse-move-out' then return
    if @isMouseInside() then return
    @window.blur()

  ###* @type import('./type/client').ClientG['watch'] ###
  watch: ->
    interval = 100
    Timer.loop interval, @update

Client = new ClientG()