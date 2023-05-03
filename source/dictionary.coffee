# @ts-check

class DictionaryG

  constructor: ->

    ###* @type import('./type/dictionary').DictionaryG['data'] ###
    @data = {}

    ###* @type import('./type/dictionary').DictionaryG['namespace'] ###
    @namespace = 'dictionary'

  ###* @type import('./type/dictionary').DictionaryG['get'] ###
  get: (name) ->

    group = @data[name]
    unless group then return name

    message = group[0]
    switch A_language
      when '0804' then message = group[1]
      # when '0411' then message = group[2]

    return $.replace message, '<br>', '\n'

  ###* @type import('./type/dictionary').DictionaryG['init'] ###
  init: -> @load()

  ###* @type import('./type/dictionary').DictionaryG['load'] ###
  load: ->

    ###* @type import('./type/dictionary').DictionaryG['data'] ###
    data = {}

    $.mixin data, Json2.read './data/dictionary/character.json'
    $.mixin data, Json2.read './data/dictionary/misc.json'

    @data = data
    return

  ###* @type import('./type/dictionary').DictionaryG['noop'] ###
  noop: -> undefined

# @ts-ignore
Dictionary = new DictionaryG()