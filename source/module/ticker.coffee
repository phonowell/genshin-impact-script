class TickerX

  interval: 200
  listBus: []
  max: 1e3
  tick: 0

  # ---

  constructor: -> setInterval @change, @interval

  change: ->

    @tick = @tick + @interval

    for fn in @listBus
      fn @tick

    if @tick >= @max
      @tick = 0

  on: (event, fn) ->

    unless event == 'change'
      return

    @listBus.Push fn