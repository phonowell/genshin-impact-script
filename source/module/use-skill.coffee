# binding

if config.data.easySkillTimer
  player
    .on 'use-skill-start', -> skillTimer.record 'start'
    .on 'use-skill-end', -> skillTimer.record 'end'