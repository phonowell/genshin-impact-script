# @ts-check

import __character_a_n__ from '../../gis-static/dictionary/character/a-n.yaml'
import __character_o_z__ from '../../gis-static/dictionary/character/o-z.yaml'
import __misc__ from '../../gis-static/dictionary/misc.yaml'

class DictionaryG

  constructor: ->

    ###* @type import('./type/dictionary').DictionaryG['data'] ###
    @data = {}

  ###* @type import('./type/dictionary').DictionaryG['get'] ###
  get: (name) ->

    group = @data[name]
    unless group then return name

    message = group[0]
    switch A_language
      when '0804' then message = group[1]
      when '0411' then message = group[2]

    return $.replace message, '<br>', '\n'

  ###* @type import('./type/dictionary').DictionaryG['init'] ###
  init: -> @load()

  ###* @type import('./type/dictionary').DictionaryG['load'] ###
  load: ->

    ###* @type import('./type/dictionary').DictionaryG['data'] ###
    data = {}

    $.mixin data, __character_a_n__
    $.mixin data, __character_o_z__
    $.mixin data, __misc__

    @data = data
    return

  ###* @type import('./type/dictionary').DictionaryG['noop'] ###
  noop: -> undefined

Dictionary = new DictionaryG()