class TickerX extends EmitterX

  emitter: ''
  interval: 200
  max: 1e3
  tick: 0

  # ---

  constructor: ->
  
    super()
    setInterval @change, @interval

  change: ->

    @tick = @tick + @interval

    @emit 'change', @tick

    if @tick >= @max
      @tick = 0