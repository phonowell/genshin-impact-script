# function

class Config

  data: {}
  source: 'config.ini'

  constructor: ->
    unless @detectRegion() then return
    @load()

  # detectPath(): void
  detectPath: ->
    name = "ahk_exe #{@get 'basic/process'}"
    __path__ = __path__
    `WinGet, __path__, ProcessPath, % name`
    @write 'basic/path', __path__

  # detectRegion(): boolean | undefined
  detectRegion: ->

    if @read 'basic/process' then return true

    unless A_language == '0804'
      @write 'basic/process', 'GenshinImpact.exe'
      return

    $.confirm (Dictionary.get 'ask_for_server'), (answer) =>

      unless answer then @write 'basic/process', 'GenshinImpact.exe'
      else @write 'basic/process', 'Yuanshen.exe'

      $.reload()

  # get(ipt: string): boolean
  get: (ipt) -> return @data[ipt]

  # load(): void
  load: ->

    # debug
    @register 'debug'

    # basic
    @register 'basic/path'
    @set 'basic/process', @read 'basic/process', 'GenshinImpact.exe'

    # better-jump
    @register 'better-jump', 'alt + space'

    # better-pickup
    @register 'better-pickup', 'alt + f'
    @register 'better-pickup/use-fast-pickup'
    @register 'better-pickup/use-quick-skip'

    # idle
    @set 'idle/use-time', @read 'idle/use-time', 60
    @register 'idle/use-mouse-move-out'

    # skill-timer
    @register 'skill-timer'

    # sound
    @register 'sound/use-beep'
    @register 'sound/use-mute-when-idle'

    # misc
    @register 'misc/use-transparency-when-idle'

  # read(ipt: string, defaultValue?: string): void
  read: (ipt, defaultValue = '') ->
    [section, key] = @split ipt
    `IniRead, result, % this.source, % section, % key, % A_Space`
    unless `result` then return $.toLowerCase defaultValue
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
      @write ipt, 0
      Hud.render 0, "#{ipt}: OFF"
    else
      @set ipt, true
      @write ipt, 1
      Hud.render 0, "#{ipt}: ON"

  # write(ipt: string, value: string): void
  write: (ipt, value) ->
    [section, key] = @split ipt
    value = " #{value}"
    `IniWrite, % value, % this.source, % section, % key`

# execute
Config = new Config()