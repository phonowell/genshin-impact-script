class WatcherX

  timer: ''

  # ---

  constructor: -> @start()

  check: ->

    client.check()
    console.check()

    if config.data.easySkillTimer
      skillTimer.check()

  start: ->

    @timer = setInterval @check, 200
    @check()

  stop: -> clearInterval @check