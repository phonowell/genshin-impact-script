# @ts-check

class ClientG extends KeyBinding

  constructor: ->
    super()

    ###* @type import('./type/client').ClientG['isSuspended'] ###
    @isSuspended = false
    ###* @type import('./type/client').ClientG['version'] ###
    @version = 49

  ###* @type import('./type/client').ClientG['init'] ###
  init: ->

    @setIcon 'on'

    $.on 'alt + f4', -> Sound.beep 2, ->
      Window2.close()
      $.exit()

    $.on 'ctrl + f5', -> Sound.beep 3, $.reload

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

    if @isSuspended then @setIcon 'off'
    else @setIcon 'on'

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

Client = new ClientG()