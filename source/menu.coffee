# @ts-check

class MenuG extends KeyBinding

  constructor: -> super()

  ###* @type import('./type/menu').MenuG['asMap'] ###
  asMap: ->

    p = ColorManager.findAny 0x2F2E2C, [
      '2%', '4%'
      '3%', '7%'
    ]
    unless p then Point.click ['96%', '94%']
    else Point.click p

  ###* @type import('./type/menu').MenuG['asMiniMenu'] ###
  asMiniMenu: ->

    p = ColorManager.findAny 0xFFCC33, [
      '76%', '92%'
      '78%', '94%'
    ]
    unless p
      $.press 'esc'
      return

    Point.click p

  ###* @type import('./type/menu').MenuG['init'] ###
  init: ->

    unless Config.get 'better-pickup/use-quick-skip' then return

    # r-button
    Scene.useExact @isMenu, =>

      @registerEvent 'right-click', 'r-button'
      @on 'right-click', -> $.press 'esc'

      return =>
        @unregisterEvent 'right-click', 'r-button'
        @off 'right-click'

    # space for map
    Scene.useExact ['map'], =>

      @registerEvent 'space', 'space'
      @on 'space', @asMap

      return =>
        @unregisterEvent 'space', 'space'
        @off 'space'

    # space for mini-menu
    Scene.useExact ['mini-menu'], =>

      @registerEvent 'space', 'space'
      @on 'space', @asMiniMenu

      return =>
        @unregisterEvent 'space', 'space'
        @off 'space'

  ###* @type import('./type/menu').MenuG['isMenu'] ###
  isMenu: ->
    if Scene.is 'half-menu' then return true
    if Scene.is 'menu' then return true
    if Scene.is 'mini-menu' then return true
    return false

Menu2 = new MenuG()