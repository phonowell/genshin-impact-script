class PaimonX

  color: [
    0xFFFFFF
    0xFAEEE0
    0xE9C48F
    0x38425C
  ]
  point:
    end: [100, 100]
    start: [0, 0]
  key: [
    'f1', 'f2', 'f3', 'f4', 'f5'
    'b', 'c', 'j', 'm'
  ]

  state:
    isVisible: false

  timer:
    close: ''

  ts:
    check: 0

  bindEvent: -> for key in @key
    $.on key, (key = key) => @close (key = key) =>
      @state.isVisible = true
      $.press key

  checkVisibility: (forced = false) ->

    if client.state.isSuspend then return

    if !forced and $.now() - @ts.check <= 5e3
      return
    @ts.check = $.now()

    unless @findColor 0
      @state.isVisible = true
      return

    if @findColor 3
      @state.isVisible = false
      return

    for n in [1, 2]
      unless @findColor n
        @state.isVisible = true
        return

    @state.isVisible = false

  close: (callback) ->

    @checkVisibility true

    unless @state.isVisible
      if callback then callback()
      return

    $.press 'esc'

    clearTimeout @timer.close
    @timer.close = setTimeout (callback = callback) ->
      if callback then callback()
    , 800

  findColor = (n) ->
    point = $.findColor @color[n], @point.start, @point.end
    return point[0] * point[1] > 0

  resetKey = -> for key in @key
    if $.getState key
      $.press "#{key}:up"