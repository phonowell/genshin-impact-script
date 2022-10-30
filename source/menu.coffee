# @ts-check

class MenuG extends KeyBinding

  constructor: -> super()

  ###* @type import('./type/menu').MenuG['asMap'] ###
  asMap: ->

    unless Scene.is 'map' then return

    p = ColorManager.findAny 0x2F2E2C, [
      '2%', '4%'
      '3%', '7%'
    ]
    unless p then @click ['96%', '94%']
    else @click p

  ###* @type import('./type/menu').MenuG['asMiniMenu'] ###
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

  ###* @type import('./type/menu').MenuG['click'] ###
  click: (p) ->
    [p0, p1] = [
      $.getPosition()
      Point.create p
    ]
    $.move p1
    $.click()
    Timer.add 50, -> $.move p0

  ###* @type import('./type/menu').MenuG['init'] ###
  init: ->
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

  ###* @type import('./type/menu').MenuG['isMenu'] ###
  isMenu: ->
    if Scene.is 'half-menu' then return true
    if Scene.is 'menu' then return true
    if Scene.is 'mini-menu' then return true
    return false

Menu2 = new MenuG()