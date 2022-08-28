### interface
type Group = [string] | [Name, string]
type Name = 'event'
  | 'fishing'
  | 'half-menu'
  | 'menu'
  | 'mini-menu'
  | 'normal'
  | 'unknown'
###

# function

class Scene extends EmitterShellX

  isFrozen: false
  name: 'unknown'
  subname: 'unknown'
  tsChange: 0

  constructor: ->
    super()

    @on 'change', =>
      console.log "scene: #{@name}/#{@subname}"
      @tsChange = $.now()

  # check(): [Name, string]
  check: ->

    if @checkIsMenu()
      if @checkIsMap() then return ['menu', 'map']
      return ['menu', 'unknown']

    if @checkIsHalfMenu()
      if @checkIsChat() then return ['half-menu', 'chat']
      return ['half-menu', 'unknown']

    if @checkIsNormal()
      if @checkIsDomain() then return ['normal', 'domain']
      return ['normal', 'unknown']

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
  checkIsNormal: -> return ColorManager.findAll 0xFFFFFF, [
    '95%', '2%'
    '97%', '6%'
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