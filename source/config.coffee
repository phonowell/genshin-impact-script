class ConfigX

  data: {}
  source: 'config.ini'

  constructor: ->

    # debug
    @data.isDebug = @read 'debug/debug', 0

    # region
    @data.region = @read 'region/region', 'en'
    if @data.region == 'en'
      @data.process = 'GenshinImpact.exe'
    else @data.process = 'YuanShen.exe'

    # feature
    for key in [
      'betterJump'
      'easySkillTimer'
      'fastPickup'
      'quickDialog'
    ]
      @data[key] = @read "feature/enable#{key}", 1

  read: (key, defaultValue = '') ->
    [__section__, __key__] = $.split key, '/'
    `IniRead, __result__, % this.source, % __section__, % __key__, % defaultValue`
    return $.toLowerCase __result__

# execute
Config = new ConfigX()