# @ts-check

class BuffG

  constructor: ->

    ###* @type import('./type/buff').BuffG['list'] ###
    @list = []

  ###* @type import('./type/buff').BuffG['has'] ###
  has: (name) -> $.includes @list, name

  ###* @type import('./type/buff').BuffG['pick'] ###
  pick: ->

    n = 0
    for name in Party.list
      unless name then continue
      unless (Character.get name, 'vision') == 'anemo' then continue
      n++

    if n >= 2 then @list = ['impetuous winds']
    else @list = []

    if $.length @list
      console.log 'buff/list:', $.join @list, ','

Buff = new BuffG()