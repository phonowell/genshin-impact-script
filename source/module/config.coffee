class ConfigX

  data:
    character: ['']
  source: 'config.ini'

  constructor: ->

    # region
    @data.process = @read 'region/process', 'YuanShen.exe'

    # feature
    for key in [
      'autoESkill'
      'easySkillTimer'
      'fastPick'
      'improvedElementalVision'
      'improvedJump'
      'improvedSprint'
    ]
      @data[key] = @read "feature/enable#{key}", 1

  read: (key, defaultValue = 1) ->
    [__section__, __key__] = $.split key, '/'
    `IniRead, __result__, % this.source, % __section__, % __key__, % defaultValue`
    return __result__