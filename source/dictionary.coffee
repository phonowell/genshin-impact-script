import __dictionary__ from 'dictionary.yaml'

# function

class Dictionary

  data: {}

  constructor: ->
    @data = __dictionary__

  # get(name: string): string
  get: (name) ->

    switch A_language
      when '0804' then message = @data[name][1]
      when '0411' then message = @data[name][2]
      else message = ''
    unless message then message = @data[name][0]

    return $.replace message, '<br>', '\n'

# execute
Dictionary = new Dictionary()