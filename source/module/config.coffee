class ConfigX

  data: {}
  source: 'config.ini'

  constructor: ->

    # feature
    for key in [
      'autoESkill'
      'easySkillTimer'
      'fastPaimonMenu'
      'fastPick'
      'fastWing'
      'improvedAttack'
      'improvedElementalVision'
      'improvedSprint'
    ]
      @data[key] = @read "feature/enable#{key}", 1

    # character
    for key in [1, 2, 3, 4]
      @data[key] = @read "character/#{key}", ''

  read: (key, defaultValue = 1) ->
    [__section__, __key__] = $.split key, '/'
    `IniRead, __result__, % this.source, % __section__, % __key__, % defaultValue`
    return __result__