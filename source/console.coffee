# @ts-check

class ConsoleG

  constructor: ->

    ###* @type import('./type/console').ConsoleG['isEnabled'] ###
    @isEnabled = false
    ###* @type import('./type/console').ConsoleG['lifetime'] ###
    @lifetime = 10e3
    ###* @type import('./type/console').ConsoleG['listContent'] ###
    @listContent = []

  ###* @type import('./type/console').ConsoleG['add'] ###
  add: (msg) ->

    id = ''
    if ($.startsWith msg, '#') and $.includes msg, ':'
      [id, string] = $.split msg, ':'
      if ($.length msg) > 40
        msg = "#{id}:\n  #{$.trim string}"
      msg = $.subString msg, 1

    tsOutdate = $.now() + @lifetime

    unless id
      $.push @listContent, [tsOutdate, msg, id]
      return

    hasId = false
    for item, i in @listContent
      unless id == item[2] then continue
      hasId = true
      @listContent[i] = [tsOutdate, msg, id]
      break

    if hasId then return
    $.push @listContent, [tsOutdate, msg, id]
    return

  ###* @type import('./type/console').ConsoleG['hide'] ###
  hide: ->
    Native 'ToolTip,, 0, 0, 20'
    return

  ###* @type import('./type/console').ConsoleG['init'] ###
  init: ->

    unless Config.get 'misc/use-debug-mode' then return

    Client.useActive =>
      @isEnabled = true
      return =>
        @isEnabled = false
        @hide()

    return

  ###* @type import('./type/console').ConsoleG['log'] ###
  log: (ipt...) ->
    unless @isEnabled then return
    @add $.join ($.map ipt, $.toString), ' '
    @render()
    return

  ###* @type import('./type/console').ConsoleG['render'] ###
  render: ->

    unless @isEnabled then return

    list = $.map @listContent, (item) -> item[1]
    text = $.trim ($.join list, '\n'), ' \n'
    [x, y] = [0 - Window2.bounds.x, Point.h '50%']

    $.noop text, x, y
    Native 'ToolTip, % text, % x, % y, 20'

    return

  ###* @type import('./type/console').ConsoleG['update'] ###
  update: ->

    unless @isEnabled then return

    now = $.now()
    @listContent = $.filter @listContent, (item) -> item[0] >= now

    @render()

# @ts-ignore
console = new ConsoleG()