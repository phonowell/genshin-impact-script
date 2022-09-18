### interface
type Name = 'event'
  | 'fishing'
  | 'half-menu'
  | 'menu'
  | 'mini-menu'
  | 'normal'
  | 'playing'
  | 'unknown'
###

# function

class Scene extends EmitterShell

  isFrozen: false
  name: 'unknown'
  subname: 'unknown'
  tsChange: 0

  constructor: ->
    super()

    @on 'change', =>
      console.log "scene: #{@name}/#{@subname}"
      @tsChange = $.now()

  # aboutHalfMenu(): [Name, Name] | null
  aboutHalfMenu: ->
    unless @checkIsHalfMenu() then return null
    if @checkIsChat() then return ['half-menu', 'chat']
    return ['half-menu', 'unknown']

  # aboutMenu(): [Name, Name] | null
  aboutMenu: ->
    unless @checkIsMenu() then return null
    if @checkIsMap() then return ['menu', 'map']
    if @checkIsPlaying() then return ['menu', 'playing']
    return ['menu', 'unknown']

  # aboutNormal(): [Name, Name] | null
  aboutNormal: ->
    unless @checkIsNormal() then return null
    if @checkIsDomain() then return ['normal', 'domain']
    return ['normal', 'unknown']

  # check(): [Name, string]
  check: ->

    result = @aboutMenu()
    if result then return result

    result = @aboutHalfMenu()
    if result then return result

    result = @aboutNormal()
    if result then return result

    if @checkIsEvent() then return ['event', 'unknown']
    if @checkIsMiniMenu() then return ['mini-menu', 'unknown']

    return ['unknown', 'unknown']

  # checkIsChat(): boolean
  checkIsChat: -> return ColorManager.findAll [0x3B4255, 0xECE5D8], [
    '58%', '2%'
    '60%', '6%'
  ]

  # checkIsDomain(): boolean
  checkIsDomain: -> return ColorManager.findAll 0xFFFFFF, [
    '1%', '9%'
    '3%', '13%'
  ]

  # checkIsEvent(): boolean
  checkIsEvent: -> return ColorManager.findAll 0xFFC300, [
    '45%', '79%'
    '55%', '82%'
  ]

  # checkIsHalfMenu(): boolean
  checkIsHalfMenu: -> return ColorManager.findAll [0x3B4255, 0xECE5D8], [
    '1%', '3%'
    '3%', '6%'
  ]

  # checkIsMap(): boolean
  checkIsMap: -> return ColorManager.findAll 0xEDE5DA, [
    '1%', '38%'
    '2%', '40%'
  ]

  # checkIsMenu(): boolean
  checkIsMenu: -> return ColorManager.findAll [0x3B4255, 0xECE5D8], [
    '95%', '3%'
    '97%', '6%'
  ]

  # checkIsMiniMenu(): boolean
  checkIsMiniMenu: -> return ColorManager.findAll 0xECE5D8, [
    '97%', '1%'
    '98%', '5%'
  ]

  # checkIsNormal(): boolean
  checkIsNormal: ->
    if ColorManager.findAll 0xFFFFFF, [
      '95%', '2%'
      '97%', '6%'
    ] then return true
    if ColorManager.findAll 0xFFFFFF, [
      '2%', '17%'
      '4%', '21%'
    ] then return true
    return false

  # checkIsPlaying(): boolean
  checkIsPlaying: -> return ColorManager.findAll [0xFFFFFF, 0xFFE92C], [
    '9%', '2%'
    '11%', '6%'
  ]

  # freeze(name: Name, subname: string, time: number): void
  freeze: (name, subname, time) ->

    unless @is name, subname
      @name = name
      @subname = subname
      @emit 'change'

    @isFrozen = true
    Timer.add 'scene/unfreeze', time, => @isFrozen = false

  # is(name: Name, subname?: string): boolean
  is: (name, subname = '') ->
    @update()
    unless subname then return name == @name
    return name == @name and subname == @subname

  # update(): void
  update: ->

    if @isFrozen then return
    if @name == 'fishing' then return

    [name, subname] = @check()
    if name == @name and subname == @subname then return
    @name = name
    @subname = subname
    @emit 'change'

# execute
Scene = new Scene()