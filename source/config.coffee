# function
class Config

  data: {}
  source: 'config.ini'

  constructor: ->

    # debug
    @data.isDebug = @read 'debug/debug', 0

    # basic
    @data.path = @read 'basic/path', 0
    @data.process = @read 'basic/process', 'GenshinImpact.exe'

    # feature
    @data.betterJump = @read 'feature/enable-better-jump', 0
    @data.fastPickup = @read 'feature/enable-fast-pickup', 0
    @data.quickEvent = @read 'feature/enable-quick-event', 0
    @data.skillTimer = @read 'feature/enable-skill-timer', 0

  # read(key: string, defaultValue: string = ''): void
  read: (key, defaultValue = '') ->
    [__section__, __key__] = $.split key, '/'
    `IniRead, __result__, % this.source, % __section__, % __key__, % defaultValue`
    return $.toLowerCase __result__

# execute
Config = new Config()