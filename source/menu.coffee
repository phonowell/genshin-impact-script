class MenuX extends KeyBindingX

  constructor: ->
    super()

    for key in [
      'esc'
      'b', 'c', 'j', 'l', 'm', 'o'
      'f1', 'f2', 'f3', 'f4', 'f5'
    ]
      @bindEvent "menu-#{key}", key

# execute
menu = new MenuX()