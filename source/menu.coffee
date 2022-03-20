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
  isMenu: -> return $.includes Scene.name, 'menu'

# execute
Menu = new Menu()