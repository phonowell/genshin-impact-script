# binding

if Config.data.easySkillTimer
  player
    .on 'use-e-start', -> skillTimer.record 'start'
    .on 'use-e-end', -> skillTimer.record 'end'