import __abc__ from '../data/character/abc.yaml'
import __def__ from '../data/character/def.yaml'
import __ghi__ from '../data/character/ghi.yaml'
import __jkl__ from '../data/character/jkl.yaml'
import __mno__ from '../data/character/mno.yaml'
import __pqr__ from '../data/character/pqr.yaml'
import __stu__ from '../data/character/stu.yaml'
import __vwx__ from '../data/character/vwx.yaml'
import __yz__ from '../data/character/yz.yaml'

# function
class CharacterX

  data: {}

  # ---

  constructor: ->

    for key, char of $.mixin {}, __abc__, __def__, __ghi__, __jkl__, __mno__, __pqr__, __stu__, __vwx__, __yz__

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