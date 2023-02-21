# @ts-check

import __map_status__ from '../../genshin-avatar-color-picker/source/result/status.yaml'

class BuffG extends EmitterShell

  constructor: ->
    super()

    ###* @type import('./type/buff').BuffG['list'] ###
    @list = []

  ###* @type import('./type/buff').BuffG['add'] ###
  add: (name) ->
    unless name then return
    if @has name then return
    $.push @list, name
    @emit 'change'
    return

  ###* @type import('./type/buff').BuffG['has'] ###
  has: (name) -> $.includes @list, name

  ###* @type import('./type/buff').BuffG['init'] ###
  init: ->

    # do not delete this line
    # or the compiler will go mad
    # and i don't know why
    $.noop console.log

    @on 'change', =>
      unless $.length @list
        console.log '#buff/list: -'
        return
      console.log '#buff/list:', $.join @list, ', '

  ###* @type import('./type/buff').BuffG['remove'] ###
  remove: (name) ->
    unless name then return
    unless @has name then return
    @list = $.filter @list, (it) -> it != name
    @emit 'change'
    return

  ###* @type import('./type/buff').BuffG['update'] ###
  update: ->

    n = 0
    for name in Party.list
      unless name then continue
      unless (Character.get name, 'vision') == 'anemo' then continue
      n++

    # impetuous winds
    if n >= 2 then @add 'impetuous winds'
    else @remove 'impetuous winds'

Buff = new BuffG()