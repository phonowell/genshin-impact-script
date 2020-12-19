class ConfigX

  data:
    character: ['']
  source: 'config.ini'

  constructor: ->

    # feature
    for key in [
      'autoESkill'
      'easySkillTimer'
      'fastPaimonMenu'
      'fastPick'
      'improvedAttack'
      'improvedElementalVision'
      'improvedJump'
      'improvedSprint'
    ]
      @data[key] = @read "feature/enable#{key}", 1

    # character
    for n in [1, 2, 3, 4]
      $.push @data.character, @read "character/#{n}", ''

  read: (key, defaultValue = 1) ->
    [__section__, __key__] = $.split key, '/'
    `IniRead, __result__, % this.source, % __section__, % __key__, % defaultValue`
    return __result__