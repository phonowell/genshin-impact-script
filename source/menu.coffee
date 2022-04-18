# function

class Menu extends KeyBinding

  constructor: ->
    super()

    if Config.data.quickEvent
      @registerEvent 'right-click', 'r-button'
      @on 'right-click', =>
        unless @isMenu() then return
        $.press 'esc'

  # isMenu(): boolean
  isMenu: ->
    if Scene.is 'menu' then return true
    if Scene.is 'half-menu' then return true
    return false

# execute
Menu = new Menu()