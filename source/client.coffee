# @ts-check

class ClientG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/client').ClientG['isSuspended'] ###
    @isSuspended = false

  ###* @type import('./type/client').ClientG['init'] ###
  init: ->

    @setIcon 'on'

    @on 'idle', =>
      @suspend true
      @setIcon 'off'
    @on 'activate', =>
      @suspend false
      @setIcon 'on'

    $.on 'alt + f4', -> Sound.beep 2, ->
      Window2.close()
      $.exit()
    $.preventInput 'alt + f4', true

    $.on 'ctrl + f5', -> Sound.beep 3, $.reload
    $.preventInput 'ctrl + f5', true

    return

  ###* @type import('./type/client').ClientG['setIcon'] ###
  setIcon: (name) ->
    path = "#{name}.ico"
    $.noop path
    Native 'Menu, Tray, Icon'
    Native 'Menu, Tray, Icon, % path, 1, 1'
    return

  ###* @type import('./type/client').ClientG['suspend'] ###
  suspend: (isSuspended) ->

    if isSuspended == @isSuspended then return
    @isSuspended = isSuspended

    $.suspend @isSuspended

  ###* @type import('./type/client').ClientG['useActive'] ###
  useActive: (fn) ->

    data = {
      callback: $.noop
      isFired: false
    }

    @on 'activate', ->
      if data.isFired then return
      data.isFired = true
      data.callback = fn()

    @on 'idle', ->
      unless data.isFired then return
      data.isFired = false
      data.callback()

  ###* @type import('./type/client').ClientG['useChange'] ###
  useChange: (listDeps, fnCheck, fnExec) ->

    data = {
      callback: $.noop
      isFired: false
    }

    fnA = ->
      if data.isFired then return
      data.isFired = true
      data.callback = fnExec()

    fnB = ->
      unless data.isFired then return
      data.isFired = false
      data.callback()

    fn = ->
      if fnCheck() then fnA()
      else fnB()

    for dep in listDeps
      dep.on 'change', fn

    return

# @ts-ignore
Client = new ClientG()