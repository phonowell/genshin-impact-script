# @ts-check

class PickerG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/picker').PickerG['listShapeForbidden'] ###
    @listShapeForbidden = []

    ###* @type import('./type/picker').PickerG['namespace'] ###
    @namespace = 'picker'

    ###* @type import('./type/picker').PickerG['tsPick'] ###
    @tsPick = 0

  ###* @type import('./type/picker').PickerG['asAutoGadget'] ###
  asAutoGadget: ->

    unless Config.get 'better-pickup/use-auto-gadget' then return
    unless State.is 'ready', 'single', 'not-domain' then return

    unless Timer.hasElapsed 'picker/auto-gadget', 1e3 then return
    unless State.checkIsGadgetUsable() then return

    $.press 'z'

  ###* @type import('./type/picker').PickerG['checkShape'] ###
  checkShape: (p) ->

    [x, y] = p
    c1 = ColorManager.format ColorManager.get [x, y + 1]
    c2 = ColorManager.format ColorManager.get [x + 1, y]

    for shape in @listShapeForbidden
      if c1 == shape[0] and c2 == shape[1]
        return true

    # console.log "#{c1} #{c2}"
    return false

  ###* @type import('./type/picker').PickerG['find'] ###
  find: ->

    if $.isPressing 'f' then return
    unless Scene.is 'normal' then return
    if State.is 'domain' then return

    p = ColorManager.findAny 0x323232, [
      '57%', '30%'
      '59%', '70%'
    ]
    unless p then return
    [_x, y] = p

    color = @findTitleColor y
    unless color then return

    if color == 0xFFFFFF
      p = ColorManager.findAny 0xFFFFFF, [
        '61%', y - Point.h 1
        '63%', y
      ]
      if p and @checkShape [p[0], p[1]] then return

    $.press 'f'

  ###* @type import('./type/picker').PickerG['findTitleColor'] ###
  findTitleColor: (y) ->

    p = ColorManager.findAny [
      0xFFFFFF
      0xCCCCCC
      0xACFF45
      0x4FF4FF
      0xF998FF
    ], [
      '63%', y
      '65%', y + 20
    ]

    if p then return p[2]
    else return 0

  ###* @type import('./type/picker').PickerG['init'] ###
  init: ->

    j = Json2.read './data/misc/shape-forbidden.json'
    @listShapeForbidden = j.list

    @registerEvent 'l-button', 'l-button'
    @registerEvent 'pick', 'f'

    @on 'pick:start', =>
      @tsPick = $.now()
      console.log '#picker/is-picking: true'

    @on 'pick:end', =>
      @tsPick = $.now()
      console.log '#picker/is-picking: false'

  ###* @type import('./type/picker').PickerG['listen'] ###
  listen: ->

    diff = $.now() - @tsPick
    unless diff > 150 then return

    unless $.isPressing 'f' then return

    if @skip() then return

    unless Scene.is 'normal' then return
    if State.is 'domain' then return

    $.press 'f'

  ###* @type import('./type/picker').PickerG['next'] ###
  next: ->

    unless Config.get 'better-pickup/enable'
      @listen()
      return

    if $.isPressing 'f'
      @listen()
      return

    @asAutoGadget()

    if (Config.get 'better-pickup/use-quick-skip') and Scene.is 'dialogue'
      @skip()
      return

    if (Config.get 'better-pickup/use-fast-pickup') and (Scene.is 'normal') and not State.is 'domain'
      @find()
      return

  ###* @type import('./type/picker').PickerG['skip'] ###
  skip: ->

    unless Scene.is 'dialogue' then return false
    if $.isPressing 'l-button' then return false # enable camera

    if $.isPressing 'f' then $.press 'f'
    else $.press 'space'

    p = ColorManager.findAny [
      0x806200
      0xFFCC32
      0xFFFFFF
    ], [
      '65%', '40%'
      '70%', '80%'
    ]
    unless p then return true

    Point.click p
    return true

# @ts-ignore
Picker = new PickerG()