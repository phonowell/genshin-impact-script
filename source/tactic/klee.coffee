module = {}

# variable

module.count = 0
module.ts = 0

# function

module.attack = (module = module) ->

  if $.now() - module.ts >= 10e3
    module.count = 0
  module.ts = $.now()

  unless module.count >= 1
    module.count++
    module.attackA()
  else
    module.count = 0
    module.attackB()

module.attackA = (module = module) ->

  $.click 'left'

  setTacticDelay 550, (module = module) ->
    $.press 'w'

    setTacticDelay 50, module.attack

module.attackB = (module = module) ->

  $.click 'left:down'

  setTacticDelay 250, (module = module) ->
    $.click 'left:up'

    setTacticDelay 850, (module = module) ->
      $.press 'w'

      setTacticDelay 50, module.attack

export default module