# function
class Config

  data: {}
  source: 'config.ini'

  constructor: ->

    # debug
    @register 'debug'

    # basic
    @register 'basic/path'
    @register 'basic/process'

    # better-jump
    @register 'better-jump', 'alt + space'

    # better-pickup
    @register 'better-pickup', 'alt + f'
    @register 'better-pickup/use-fast-pickup'
    @register 'better-pickup/use-quick-skip'

    # skill-timer
    @register 'skill-timer'

    # sound
    @register 'sound/use-beep'
    @register 'sound/use-mute-when-idle'

  # get(ipt: string): boolean
  get: (ipt) -> return @data[ipt]

  # read(ipt: string, defaultValue?: string): void
  read: (ipt, defaultValue = '') ->
    [section, key] = @split ipt
    `IniRead, result, % this.source, % section, % key, % defaultValue`
    return $.toLowerCase `result`

  # register(ipt: string, hotkey?: string): void
  register: (ipt, hotkey = '') ->
    @set ipt, @read ipt, 0
    if hotkey then $.on hotkey, => @toggle ipt

  # set(ipt: string, value: boolean): void
  set: (ipt, value) -> @data[ipt] = value

  # split(ipt: string): [string, string]
  split: (ipt) ->
    unless ipt then throw new Error 'invalid ipt'
    [section, key] = $.split ipt, '/'
    unless section then throw new Error "invalid ipt: #{ipt}"
    unless key then key = 'enable'
    return [section, key]

  # toggle(ipt: string): void
  toggle: (ipt) ->
    if @get ipt
      @set ipt, false
      @write ipt, ' 0'
      Hud.render 0, "#{ipt}: OFF"
    else
      @set ipt, true
      @write ipt, ' 1'
      Hud.render 0, "#{ipt}: ON"

  # write(ipt: string, value: string): void
  write: (ipt, value) ->
    [section, key] = @split ipt
    `IniWrite, % value, % this.source, % section, % key`

# execute
Config = new Config()