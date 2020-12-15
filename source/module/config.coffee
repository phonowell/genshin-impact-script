class ConfigX

  data: {}
  source: 'config.ini'

  constructor: ->
    for key in [
      'autoESkill'
      'backJump'
      'easySkillTimer'
      'fastPaimonMenu'
      'fastPick'
      'fastWing'
      'improvedElementalVision'
      'improvedSprint'
    ]
      @data[key] = @read "feature/enable#{key}"

  read: (key, defaultValue = 1) ->
    [__section__, __key__] = $.split key, '/'
    `IniRead, __result__, % this.source, % __section__, % __key__, % defaultValue`
    return __result__