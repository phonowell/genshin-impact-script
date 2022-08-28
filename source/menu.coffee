# function

class Menu extends KeyBinding

  constructor: ->
    super()
    # @watch()

    unless Config.get 'better-pickup/use-quick-skip' then return

    # r-button
    @registerEvent 'right-click', 'r-button'
    @on 'right-click', =>
      unless @isMenu() then return
      $.press 'esc'

    # space
    @registerEvent 'space', 'space'
    @on 'space', =>
      @asMap()
      @asMiniMenu()

  # asMap(): void
  asMap: ->

    unless Scene.is 'menu', 'map' then return

    p = ColorManager.findAny 0x2F2E2C, [
      '2%', '4%'
      '3%', '7%'
    ]
    unless p then p = ['96%', '94%']

    @click p

  # asMiniMenu(): void
  asMiniMenu: ->

    unless Scene.is 'mini-menu' then return

    p = ColorManager.findAny 0xFFCC33, [
      '76%', '92%'
      '78%', '94%'
    ]
    unless p
      $.press 'esc'
      return

    @click p

  # click(p: Point): void
  click: (p) ->
    p = Point.create p
    old = $.getPosition()
    $.move p
    $.click()
    Timer.add 50, -> $.move old

  # isMenu(): boolean
  isMenu: ->
    if Scene.is 'half-menu' then return true
    if Scene.is 'menu' then return true
    if Scene.is 'mini-menu' then return true
    return false

  # watch(): void
  # watch: ->

  #   interval = 100
  #   token = 'menu/watch'

  #   fn = =>
  #     unless Config.get 'better-pickup/use-quick-skip' then return
  #     @asMiniMenu()

  #   Client.on 'idle', -> Timer.remove token
  #   Client.on 'activate', -> Timer.loop token, interval, fn

# execute
Menu = new Menu()