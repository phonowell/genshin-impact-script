import __character_a_m__ from '../../data/character-a-m.yaml'
import __character_n_z__ from '../../data/character-n-z.yaml'

class CharacterX

  data: {}

  constructor: -> for name, char of $.mixin __character_a_m__, __character_n_z__
    @data[name] =
      backendE: char['backend-e']
      cdE: @getValueIntoArray char['cd-e']
      cdQ: char['cd-q']
      colorAvatar: char['color-avatar']
      durationE: @getValueIntoArray char['duration-e']
      durationQ: char['duration-q']
      tactic: @getTactic Config.read "#{name}/tactic", 0
      typeApr: Config.read "#{name}/type-apr", 0
      typeE: char['type-e']

  getValueIntoArray: (value) -> switch $.type value
    when 'array' then return value
    when 'number' then return [value, value]
    else return [0, 0]

  getTactic: (value) ->

    unless value
      return 0

    value = $.replace value, ' ', ''
    listAll = []

    for group in $.split value, ';'
      listGroup = []
      for item in $.split group, ','
        $.push listGroup, item
      $.push listAll, listGroup

    return listAll

# execute
Character = new CharacterX()