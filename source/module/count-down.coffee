timer.countDown = ''

countDown = (time) ->
  unless config.data.easySkillTimer then return
  clearTimeout timer.countDown
  timer.countDown = $.delay time, $.beep