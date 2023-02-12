# @ts-check

class ConfigG

  constructor: ->

    ###* @type import('./type/config').ConfigG['data'] ###
    @data = {}
    ###* @type import('./type/config').ConfigG['source'] ###
    @source = 'config.ini'

  ###* @type import('./type/config').ConfigG['detectRegion'] ###
  detectPath: ->
    name = "ahk_exe #{@get 'basic/process'}"

    $.noop name
    path = ''
    Native 'WinGet, path, ProcessPath, % name'

    @write 'basic/path', path
    return

  ###* @type import('./type/config').ConfigG['detectRegion'] ###
  detectRegion: ->

    if @read 'basic/process' then return true

    unless A_language == '0804'
      @write 'basic/process', 'GenshinImpact.exe'
      return undefined

    $.confirm (Dictionary.get 'ask_for_server'), (answer) =>

      unless answer then @write 'basic/process', 'GenshinImpact.exe'
      else @write 'basic/process', 'Yuanshen.exe'

      $.reload()

    return undefined

  ###* @type import('./type/config').ConfigG['get'] ###
  get: (ipt) -> @data[ipt]

  ###* @type import('./type/config').ConfigG['init'] ###
  init: ->
    unless @detectRegion() then return
    @load()

  ###* @type import('./type/config').ConfigG['load'] ###
  load: ->

    # basic
    @register 'basic/path'
    @set 'basic/process', @read 'basic/process', 'GenshinImpact.exe'

    # better-pickup
    @register 'better-pickup/enable', 'alt + f'
    @register 'better-pickup/use-fast-pickup'
    @register 'better-pickup/use-quick-skip'

    # skill-timer
    @register 'skill-timer/enable'

    # misc
    @register 'misc/use-beep'
    @register 'misc/use-better-jump', 'alt + space'
    @register 'misc/use-controller'
    @register 'misc/use-debug-mode'
    @register 'misc/use-mute'

  ###* @type import('./type/config').ConfigG['read'] ###
  read: (ipt, defaultValue = '') ->
    [section, key] = $.split ipt, '/'
    $.noop section, key
    result = ''
    Native 'IniRead, result, % this.source, % section, % key, % A_Space'
    unless result then return $.toLowerCase defaultValue
    return $.toLowerCase result

  ###* @type import('./type/config').ConfigG['register'] ###
  register: (ipt, key = '') ->
    @set ipt, @read ipt, '0'
    if key then $.on key, => @toggle ipt
    return

  ###* @type import('./type/config').ConfigG['set'] ###
  set: (ipt, value) ->
    @data[ipt] = value
    return

  ###* @type import('./type/config').ConfigG['toggle'] ###
  toggle: (ipt) ->
    if @get ipt
      @set ipt, $.toString false
      @write ipt, '0'
      Hud.render 0, "#{ipt}: OFF"
    else
      @set ipt, $.toString true
      @write ipt, '1'
      Hud.render 0, "#{ipt}: ON"
    return

  ###* @type import('./type/config').ConfigG['write'] ###
  write: (ipt, value) ->
    [section, key] = $.split ipt, '/'
    value = " #{value}"
    $.noop section, key
    Native 'IniWrite, % value, % this.source, % section, % key'
    return

Config = new ConfigG()