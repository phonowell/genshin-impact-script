# @ts-check

class DashboardG

  ###* @type import('./type/dashboard').DashboardG['format'] ###
  format: (n) ->
    if ($.Math.abs n) > 1e3 then return "#{$.Math.floor n * 0.001}s"
    return "#{Round n * 0.001, 1}s"

  ###* @type import('./type/dashboard').DashboardG['hide'] ###
  hide: (n) -> Hud.render n, ''

  ###* @type import('./type/dashboard').DashboardG['render'] ###
  render: (n, message) -> Hud.render n, message

  ###* @type import('./type/dashboard').DashboardG['renderProgress'] ###
  renderProgress: (n, m, method) ->

    listChar = ['◾️', '◽️', '⬛']

    percent = n * 5 / m
    if method == 'ceil' then percent = $.Math.ceil percent
    else if method == 'floor' then percent = $.Math.floor percent
    else percent = $.Math.round percent

    listResult = ['']
    for i in [1, 2, 3, 4, 5]
      if percent > i then $.push listResult, listChar[0]
      else if percent == i then $.push listResult, listChar[2]
      else $.push listResult, listChar[1]
    return $.join listResult, ''

  ###* @type import('./type/dashboard').DashboardG['update'] ###
  update: ->

    {
      listCache
      listCountDown
      listDuration
    } = Skill
    now = $.now()

    for n in [1, 2, 3, 4, 5]

      unless listCountDown[n] or listDuration[n] then continue

      if now >= listCountDown[n] then listCountDown[n] = 0
      if now >= listDuration[n] then listDuration[n] = 0

      listMessage = []

      tagCurrent = ''
      if n == Party.current then tagCurrent = ' 🎮'

      if listCountDown[n]
        $progress = @renderProgress listCache[n][0] - (listCountDown[n] - now), listCache[n][0], 'floor'
        formatted = @format now - listCountDown[n]
        $.push listMessage, "#{$progress} #{formatted}#{tagCurrent}"
      else $.push listMessage, "◾️◾️◾️◾️◾️#{tagCurrent}"

      if listDuration[n]
        $progress = @renderProgress listDuration[n] - now, listCache[n][1], 'ceil'
        formatted = @format listDuration[n] - now
        $.push listMessage, "#{$progress} [#{formatted}]"

      unless ($.Math.abs listCountDown[n]) + listDuration[n]
        @hide n
        continue

      @render n, $.join listMessage, '\n'

    return

Dashboard = new DashboardG()