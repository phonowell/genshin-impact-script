# function

class Upgrader

  target: '0.0.41'

  # check(): void
  check: ->

    $.get "https://github.com/phonowell/genshin-impact-script/releases/tag/#{@target}", (result) =>

      unless result
        Timer.add 600e3, @check
        return

      if result == 'Not Found' then return

      msg = $.join [
        "Found new version: v#{@target}"
        'Upgrade right now?'
      ], '\n'

      $.confirm msg, (answer) ->
        unless answer then return
        $.open 'https://github.com/phonowell/genshin-impact-script/releases'

# execute
Upgrader = new Upgrader()