import __ag__ from '../data/character/a-g.yaml'
import __hn__ from '../data/character/h-n.yaml'
import __ot__ from '../data/character/o-t.yaml'
import __uz__ from '../data/character/u-z.yaml'

class CharacterX

  data: {}

  constructor: -> for name, char of $.mixin ($.mixin __ag__, __hn__), ($.mixin __ot__, __uz__)
    @data[name] =
      cdE: @getValueIntoArray char['cd-e']
      cdQ: char['cd-q']
      colorAvatar: char['color-avatar']
      durationE: @getValueIntoArray char['duration-e']
      durationQ: char['duration-q']
      nameCN: char['name-cn']
      nameEN: char['name-en']
      tactic: @getTactic Config.read "#{name}/tactic", 0
      typeApr: Config.read "#{name}/type-apr", 0
      typeE: char['type-e']
      weapon: char.weapon

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