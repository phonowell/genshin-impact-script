class PaimonX

  color: [
    0xFFFFFF
    0xECE5D8
    0x3B4255
  ]

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

    if !forced and $.now() - @ts.check <= 1e3
      return
    @ts.check = $.now()

    # check

    unless @findColor 0
      @state.isVisible = true
      return

    if (@findColor 1) or @findColor 2
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

  findColor: (n) ->

    pointStart = [client.width - 80, 0]
    pointEnd = [client.width, 80]

    point = $.findColor @color[n], pointStart, pointEnd
    return point[0] * point[1] > 0

  resetKey: -> for key in @key
    if $.getState key
      $.press "#{key}:up"