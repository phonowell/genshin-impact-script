import __character__ from '../../gis-static/dictionary/character.yaml'
import __misc__ from '../../gis-static/dictionary/misc.yaml'

# function

class Dictionary

  data: {}

  constructor: -> @load()

  # get(name: string): string
  get: (name) ->

    switch A_language
      when '0804' then message = @data[name][1]
      when '0411' then message = @data[name][2]
      else message = ''
    unless message then message = @data[name][0]

    return $.replace message, '<br>', '\n'

  # load(): void
  load: ->
    data = {}
    $.mixin data, __character__
    $.mixin data, __misc__
    @data = data

# execute
Dictionary = new Dictionary()