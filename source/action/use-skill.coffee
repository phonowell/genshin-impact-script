# binding

Player
  .on 'use-e:start', -> SkillTimer.record 'start'
  .on 'use-e:end', -> SkillTimer.record 'end'
  .on 'use-q:start', Player.useQ

for key in [1, 2, 3, 4, 5]
  $.on "alt + #{key}", ->

    if key == Party.current
      Player.useQ()
      return

    Player.switchQ key