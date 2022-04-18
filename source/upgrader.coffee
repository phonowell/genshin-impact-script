# function
class Upgrader

  target: '0.0.34'

  # check(): void
  check: ->

    $.get "https://github.com/phonowell/genshin-impact-script/releases/tag/#{@target}", (result) =>

      unless result
        Timer.add 600e3, @check
        return

      if result == 'Not Found' then return

      msg = "Found new version: v#{@target}\nUpgrade right now?"

      $.confirm msg, (answer) ->
        unless answer then return
        $.open 'https://github.com/phonowell/genshin-impact-script/releases'

# execute
Upgrader = new Upgrader()