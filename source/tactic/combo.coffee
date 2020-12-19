module = {}

# function

module.attack = (module = module) -> module.attackA()

module.attackA = (module = module) ->

  $.click 'left'

  setTacticDelay 200, module.attack

export default module