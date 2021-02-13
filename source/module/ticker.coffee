class TickerX extends EmitterX

  interval: 50
  max: 1e3
  tick: 0

  # ---

  constructor: ->
    super()
    setInterval @update, @interval

  update: ->
    @tick = @tick + @interval
    @emit 'change', @tick
    if @tick >= @max
      @tick = 0

# execute
ticker = new TickerX()