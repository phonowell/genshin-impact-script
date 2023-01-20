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

    Native 'Menu, Tray, Icon, on.ico,, 1'

    @useActive =>

      console.log '#client: activate'
      Native 'Menu, Tray, Icon, on.ico'
      @suspend false

      return =>

        console.log '#client: idle'
        Native 'Menu, Tray, Icon, off.ico'
        @suspend true

    $.on 'alt + f4', -> Sound.beep 2, ->
      Window2.close()
      $.exit()

    $.on 'ctrl + f5', -> Sound.beep 3, $.reload

    return

  ###* @type import('./type/client').ClientG['suspend'] ###
  suspend: (isSuspended) ->

    if isSuspended
      if @isSuspended then return
      @isSuspended = true
      $.suspend true
      return

    unless isSuspended
      unless @isSuspended then return
      @isSuspended = false
      $.suspend false
      return

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