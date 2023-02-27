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
    do =>
      token = 'right-click/menu'
      @on token, -> $.press 'esc'
      Client.useChange [Scene], ->
        if Scene.is 'half-menu' then return true
        if Scene.is 'menu' then return true
        if Scene.is 'mini-menu' then return true
        return false
      , =>
        @registerEvent token, 'r-button'
        return => @unregisterEvent token, 'r-button'

    # space for map
    do =>
      token = 'space/map'
      @on token, @asMap
      Scene.useExact ['map'], =>
        @registerEvent token, 'space'
        return => @unregisterEvent token, 'space'

    # space for mini-menu
    do =>
      token = 'space/mini-menu'
      @on token, @asMiniMenu
      Scene.useExact ['mini-menu'], =>
        @registerEvent token, 'space'
        return => @unregisterEvent token, 'space'

# @ts-ignore
Menu2 = new MenuG()