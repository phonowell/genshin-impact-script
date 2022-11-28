# @ts-check

class WindowG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/window').WindowG['bounds'] ###
    @bounds = {x: 0, y: 0, width: 0, height: 0}
    ###* @type import('./type/window').WindowG['isActive'] ###
    @isActive = false
    ###* @type import('./type/window').WindowG['isFullScreen'] ###
    @isFullScreen = false
    ###* @type import('./type/window').WindowG['position'] ###
    @position = [1, 1]
    ###* @type import('./type/window').WindowG['window'] ###
    @window = $.window ''

  ###* @type import('./type/window').WindowG['close'] ###
  close: ->
    @window.minimize()
    @window.close()

  ###* @type import('./type/window').WindowG['focus'] ###
  focus: ->
    @window.focus()
    if @isMouseInside() then return
    $.move [
      @bounds.width * 0.5
      @bounds.height * 0.5
    ]

  ###* @type import('./type/window').WindowG['getState'] ###
  getState: ->
    @bounds = @window.getBounds()
    @isFullScreen = @window.isFullScreen()
    return

  ###* @type import('./type/window').WindowG['getTaskBarBounds'] ###
  getTaskBarBounds: ->
    [x, y, width, height] = [0, 0, 0, 0]

    name = 'ahk_class Shell_TrayWnd'
    $.noop name
    Native 'WinGetPos, x, y, width, height, % name'

    return {x, y, width, height}

  ###* @type import('./type/window').WindowG['init'] ###
  init: ->
    @window = $.window $.toString Config.get 'basic/process'

    unless @window.isExists()
      if Config.get 'basic/path'
        try $.open $.join [
          $.toString Config.get 'basic/path'
          $.toString Config.get 'basic/arguments'
        ], ' '
        catch then $.alert Dictionary.get 'invalid_path'

    @window.wait @main

  ###* @type import('./type/window').WindowG['isMouseInside'] ###
  isMouseInside: ->
    [x, y] = $.getPosition()
    if x < 0 then return false
    if x >= @bounds.width then return false
    if y < 0 then return false
    if y >= @bounds.height then return false
    return true

  ###* @type import('./type/window').WindowG['main'] ###
  main: ->

    Config.detectPath()
    @watch()

    @on 'leave', =>
      console.log '#window: leave'
      @isActive = false

      @window.setPriority 'low'

      Client.emit 'idle'

    @on 'enter', =>
      console.log '#window: enter'
      @isActive = true

      @window.setPriority 'normal'
      @getState()
      @setStyle()
      Timer.add 1e3, @getState

      Client.emit 'activate'
      @focus()

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

  ###* @type import('./type/window').WindowG['setPosition'] ###
  setPosition: ->

    [x, y] = @position
    width = ($.Math.round @bounds.width / 80) * 80
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
        h = @getTaskBarBounds().height
        top = A_ScreenHeight - height - h

    name = "ahk_exe #{Config.get 'basic/process'}"
    $.noop name, left, top, width, height
    Native 'WinMove, % name,, % left, % top, % width, % height'
    @getState()

  ###* @type import('./type/window').WindowG['setStyle'] ###
  setStyle: ->
    @window.setStyle -0x00040000 # border
    @window.setStyle -0x00C00000 # caption
    if @isFullScreen then return
    @setPosition()

  ###* @type import('./type/window').WindowG['watch'] ###
  watch: ->
    interval = 100
    Timer.loop interval, =>
      if @window.isActive()
        unless @isActive then @emit 'enter'

        # blur
        unless Config.get 'idle/use-mouse-move-out' then return
        if @isMouseInside() then return
        @window.blur()
        
        return
      else
        if @isActive then @emit 'leave'
        return

Window2 = new WindowG()