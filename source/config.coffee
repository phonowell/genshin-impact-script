class ConfigX

  data: {}
  source: 'config.ini'

  constructor: ->

    # debug
    @data.isDebug = @read 'debug/debug', 0
    @data.autoPickup = @read 'debug/enable-auto-pickup', 0

    # basic
    @data.performance = @read 'basic/performance', 'medium'
    @data.region = @read 'basic/region', 'en'
    if @data.region == 'en'
      @data.process = 'GenshinImpact.exe'
    else @data.process = 'YuanShen.exe'

    # feature
    @data.betterJump = @read 'feature/enable-better-jump', 1
    @data.fastPickup = @read 'feature/enable-fast-pickup', 1
    @data.quickEvent = @read 'feature/enable-quick-event', 1
    @data.skillTimer = @read 'feature/enable-skill-timer', 1

  read: (key, defaultValue = '') ->
    [__section__, __key__] = $.split key, '/'
    `IniRead, __result__, % this.source, % __section__, % __key__, % defaultValue`
    return $.toLowerCase __result__

# execute
Config = new ConfigX()