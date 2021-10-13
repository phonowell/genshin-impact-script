import __ag__ from '../data/character/a-g.yaml'
import __hn__ from '../data/character/h-n.yaml'
import __ot__ from '../data/character/o-t.yaml'
import __uz__ from '../data/character/u-z.yaml'

# function
class CharacterX

  data: {}

  # ---

  constructor: ->

    for key, char of $.mixin {}, __ag__, __hn__, __ot__, __uz__

      @data[key] =
        cdE: @padArray @makeValueIntoArray char['cd-e']
        cdQ: char['cd-q']
        color: @makeValueIntoArray char['color']
        durationE: @padArray @makeValueIntoArray char['duration-e']
        durationQ: char['duration-q']
        nameCN: char['name-cn']
        nameEN: char['name-en']
        typeE: char['type-e']
        weapon: char.weapon

      @data[key].audio = @pickMulti key, 'audio'
      @data[key].onLongPress = @makeOnLongPress @pickMulti key, 'on-long-press'
      @data[key].onSwitch = @pickMulti key, 'on-switch'

  # padArray(list: [number] | [number, number]): [number, number]
  padArray: (list) ->
    if ($.length list) == 2 then return list
    $.push list, list[0]
    return list

  # pickMulti(key: string, name: string): string | undefined
  pickMulti: (key, name) ->

    value = Config.read "#{key}/#{name}", 0
    if value then return value

    # value = Config.read "#{@data[key].nameCN}/#{name}", 0
    # if value then return value

    value = Config.read "#{$.toLowerCase @data[key].nameEN}/#{name}", 0
    return value

  # makeOnLongPress(value: string): string[] | undefined
  makeOnLongPress: (value) ->

    unless value then return 0

    value = $.replace value, ' ', ''
    listAll = []

    for group in $.split value, ';'
      listGroup = []
      for item in $.split group, ','
        $.push listGroup, item
      $.push listAll, listGroup

    return listAll

  # makeValueIntoArray: (value: number | number[]): number[]
  makeValueIntoArray: (value) -> switch $.type value
    when 'array' then return value
    when 'number' then return [value]
    else return [0]

# execute
Character = new CharacterX()