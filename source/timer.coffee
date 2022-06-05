### interface
type Fn = () => unknown
###

# function

class Timer

  cacheTimer: {}
  cacheTs: {}

  # add(id?: string, time?: number, fn?: Fn): void
  add: (args...) ->

    if Client.isSuspend then return
    [id, time, fn] = @pick args

    hasId = !!id

    if hasId and @cacheTimer[id] then $.clearTimeout @cacheTimer[id]
    unless time then return

    result = $.setTimeout fn, time
    if hasId then @cacheTimer[id] = result

  # checkInterval(id: string, time: number): boolean
  checkInterval: (id, time) ->

    now = $.now()

    unless @cacheTs[id]
      @cacheTs[id] = now
      return true

    unless now - @cacheTs[id] > time
      return false

    @cacheTs[id] = now
    return true

  # has(id: string): boolean
  has: (id) ->
    if @cacheTimer[id] then return true
    else return false

  # loop(id?: string, time?: number, fn?: Fn): void
  loop: (args...) ->

    if Client.isSuspend then return
    [id, time, fn] = @pick args

    hasId = !!id

    if hasId and @cacheTimer[id] then $.clearInterval @cahce[id]
    unless time then return

    result = $.setInterval fn, time
    if hasId then @cacheTimer[id] = result

  # pick(args: unknown[]): [string, number, Fn]
  pick: (args) ->
    len = $.length args
    if len == 1 then return [args[0], 0, 0]
    else if len == 2 then return ['', args[0], args[1]]
    else return args

  # reset(): void
  reset: -> for id, t of @cacheTimer
    $.clearTimeout t
    @cacheTimer[id] = 0

  # remove(id: string): void
  remove: (id) ->
    unless @has id then return
    $.clearTimeout @cacheTimer[id]
    @cacheTimer[id] = 0

# execute
Timer = new Timer()