class ConfigX

  data: {}
  source: 'config.ini'

  constructor: ->

    # region
    @data.process = @read 'region/process', 'YuanShen.exe'

    # feature
    for key in [
      'betterElementalVision'
      'betterJump'
      'betterSprint'
      'easySkillTimer'
      'fastPickup'
    ]
      @data[key] = @read "feature/enable#{key}", 1

  read: (key, defaultValue = '') ->

    $$.vt 'config.read', key, 'string'

    [__section__, __key__] = $.split key, '/'
    `IniRead, __result__, % this.source, % __section__, % __key__, % defaultValue`
    return __result__

# execute
Config = new ConfigX()