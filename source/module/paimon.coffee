class PaimonX

  color: [
    0xFFFFFF
    0xFAEEE0
    0xE9C48F
  ]
  point:
    end: [100, 100]
    start: [0, 0]
  key: [
    'f1', 'f2', 'f3', 'f4', 'f5'
    'b', 'c', 'j', 'm'
  ]

  timer: {}
  ts: {}

  bind: -> for key in @key
    $.on key, (key = key) => @close (key = key) -> $.press key

  close: (callback) ->

    if @isVisible()
      if callback then callback()
      return

    $.press 'esc'

    @ts.close = $.now()
    clearInterval @timer.close
    @timer.close = setInterval (callback = callback) =>

      unless @isVisible() or $.now() - @ts.close >= 1e3
        return

      clearInterval @timer.close
      if callback then callback()

    , 100

  isVisible: ->

    for n in [1, 2, 3]
      point = $.findColor @color[n], @point.start, @point.end
      unless point[1] * point[2] > 0
        return false

    return true

  resetKey = -> for key in @key
    if $.getState key
      $.press "#{key}:up"