# @ts-check

class CharacterG

  constructor: ->

    ###* @type import('./type/character').CharacterG['data'] ###
    @data = {}

    ###* @type import('./type/character').CharacterG['listVision'] ###
    @listVision = [
      'anemo'
      'cryo'
      'dendro'
      'electro'
      'geo'
      'hydro'
      'pyro'
    ]

    ###* @type import('./type/character').CharacterG['listWeapon'] ###
    @listWeapon = [
      'bow'
      'catalyst'
      'claymore'
      'polearm'
      'sword'
    ]

    ###* @type import('./type/character').CharacterG['namespace'] ###
    @namespace = 'character'

    ###* @type import('./type/character').CharacterG['source'] ###
    @source = 'character.ini'

  ###* @type import('./type/character').CharacterG['get'] ###
  get: (name, key = undefined) ->
    unless name then return ''
    unless key then return @data[name]
    return @data[name][key]

  ###* @type import('./type/character').CharacterG['init'] ###
  init: -> @load()

  ###* @type import('./type/character').CharacterG['is'] ###
  is: (name, keyword) ->

    if keyword == '5-star'
      return (@get name, 'star') == 5

    if $.includes @listVision, keyword
      return (@get name, 'vision') == keyword

    if $.includes @listWeapon, keyword
      return (@get name, 'weapon') == keyword

    return false

  ###* @type import('./type/character').CharacterG['isTuple'] ###
  isTuple: (ipt) -> ($.length ipt) == 2

  ###* @type import('./type/character').CharacterG['load'] ###
  load: ->

    # line below for moudles sorting
    # do not remove
    Dictionary.noop()

    ###* @type import('./type/character').dataRaw ###
    data = {}

    j = Json2.read './data/character/index.json'
    list = Utility.makeList 'string', j.data

    for name in list
      data[name] = Json2.read "./data/character/#{name}.json"

    for name, char of data

      @data[name] =
        cdE: @padArray @makeValueIntoArray char['cd-e']
        cdQ: char['cd-q']
        color: char['color']
        constellation: 0
        durationE: @padArray @makeValueIntoArray char['duration-e']
        durationQ: char['duration-q']
        onLongPress: ''
        onSideButton1: ''
        onSideButton2: ''
        onSwitch: ''
        star: char['star']
        typeE: char['type-e']
        typeSprint: char['type-sprint']
        vision: char.vision
        weapon: char.weapon

      @data[name].constellation = $.toNumber @pickFromFile name, 'constellation'
      @data[name].onLongPress = $.toString @pickFromFile name, 'on-long-press'
      @data[name].onSideButton1 = $.toString @pickFromFile name, 'on-side-button-1'
      @data[name].onSideButton2 = $.toString @pickFromFile name, 'on-side-button-2'
      @data[name].onSwitch = $.toString @pickFromFile name, 'on-switch'

      if name == 'traveler'
        @data[name].vision = $.toString @pickFromFile name, 'vision'
    return

  ###* @type import('./type/character').CharacterG['makeValueIntoArray'] ###
  makeValueIntoArray: (value) ->
    if $.isNumber value then return [value]
    if $.isArray value then return value
    return [0]

  ###* @type import('./type/character').CharacterG['padArray'] ###
  padArray: (list) ->
    if @isTuple list then return list
    return [list[0], list[0]]

  ###* @type import('./type/character').CharacterG['pickFromFile'] ###
  pickFromFile: (name, key) ->

    # like hu_tao
    target = @read name
    if target then return @read "#{name}/#{key}", 0

    # like hu tao
    nameDict = $.toLowerCase Dictionary.data[name][0]
    target = @read nameDict
    if target then return @read "#{nameDict}/#{key}", 0

    # like 胡桃
    if A_language == '0804'
      nameDict = $.toLowerCase Dictionary.get name
      target = @read nameDict
      if target then return @read "#{nameDict}/#{key}", 0

    # weapon
    target = @read @data[name].weapon
    if target then return @read "#{@data[name].weapon}/#{key}", 0

    # all
    target = @read 'all'
    if target then return @read "all/#{key}", 0

    return 0

  # read(ipt: string, defaultValue?: string): string
  ###* @type import('./type/character').CharacterG['read'] ###
  read: (ipt, defaultValue = '') ->
    [section, key] = $.split ipt, '/'
    result = ''
    $.noop result, section, key, defaultValue
    if key then Native 'IniRead, result, % this.source, % section, % key, % defaultValue'
    else Native 'IniRead, result, % this.source, % section'
    return $.toLowerCase result

# @ts-ignore
Character = new CharacterG()