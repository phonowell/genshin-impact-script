# function

class Upgrader

  target: 43

  # check(): void
  check: ->

    $.get "https://github.com/phonowell/genshin-impact-script/releases/tag/0.0.#{@target}", (result) =>

      unless result
        Timer.add 600e3, @check
        return

      if result == 'Not Found' then return

      $.confirm (Dictionary.get 'found_new_version'), (answer) ->
        unless answer then return
        $.open 'https://github.com/phonowell/genshin-impact-script/releases'

# execute
Upgrader = new Upgrader()