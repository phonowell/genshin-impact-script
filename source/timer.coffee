# @ts-check

class TimerG

  constructor: ->
    ###* @type import('./type/timer').TimerG['cacheTimer'] ###
    @cacheTimer = {}
    ###* @type import('./type/timer').TimerG['cacheTs'] ###
    @cacheTs = {}

  ###* @type import('./type/timer').TimerG['add'] ###
  add: (args...) ->

    if Client.isSuspended then return
    [id, time, fn] = @pick args

    hasId = !!id

    if hasId and @cacheTimer[id] then $.clearTimeout @cacheTimer[id]
    unless time then return

    result = $.setTimeout fn, time
    if hasId then @cacheTimer[id] = result

    return

  ###* @type import('./type/timer').TimerG['checkInterval'] ###
  checkInterval: (id, time) ->

    now = $.now()

    unless @cacheTs[id]
      @cacheTs[id] = now
      return true

    unless now - @cacheTs[id] > time
      return false

    @cacheTs[id] = now
    return true

  ###* @type import('./type/timer').TimerG['has'] ###
  has: (id) ->
    if @cacheTimer[id] then return true
    else return false

  ###* @type import('./type/timer').TimerG['isTuple'] ###
  isTuple: (ipt) ->
    unless ($.length ipt) == 3 then return false
    unless $.isString ipt[0] then return false
    unless $.isNumber ipt[1] then return false
    unless $.isFunction ipt[2] then return false
    return true

  ###* @type import('./type/timer').TimerG['loop'] ###
  loop: (args...) ->

    if Client.isSuspended then return
    [id, time, fn] = @pick args

    hasId = !!id

    if hasId and @cacheTimer[id] then $.clearInterval @cacheTimer[id]
    unless time then return

    result = $.setInterval fn, time
    if hasId then @cacheTimer[id] = result
    return

  ###* @type import('./type/timer').TimerG['pick'] ###
  pick: (args) ->
    if @isTuple args then return args
    return ['', args[0], args[1]]

  ###* @type import('./type/timer').TimerG['reset'] ###
  reset: ->
    for id, t of @cacheTimer
      $.clearTimeout t
      $.delete @cacheTimer, id
    return

  ###* @type import('./type/timer').TimerG['remove'] ###
  remove: (id) ->
    unless @has id then return
    $.clearTimeout @cacheTimer[id]
    $.delete @cacheTimer, id
    return

Timer = new TimerG()