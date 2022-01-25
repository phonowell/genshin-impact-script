import __albedo__ from '../data/character/albedo.yaml'
import __aloy__ from '../data/character/aloy.yaml'
import __amber__ from '../data/character/amber.yaml'
import __arataki_itto__ from '../data/character/arataki_itto.yaml'
import __barbara__ from '../data/character/barbara.yaml'
import __beidou__ from '../data/character/beidou.yaml'
import __bennett__ from '../data/character/bennett.yaml'
import __chongyun__ from '../data/character/chongyun.yaml'
import __diluc__ from '../data/character/diluc.yaml'
import __diona__ from '../data/character/diona.yaml'
import __eula__ from '../data/character/eula.yaml'
import __fischl__ from '../data/character/fischl.yaml'
import __ganyu__ from '../data/character/ganyu.yaml'
import __gorou__ from '../data/character/gorou.yaml'
import __hu_tao__ from '../data/character/hu_tao.yaml'
import __jean__ from '../data/character/jean.yaml'
import __kaedehara_kazuha__ from '../data/character/kaedehara_kazuha.yaml'
import __kaeya__ from '../data/character/kaeya.yaml'
import __kamisato_ayaka__ from '../data/character/kamisato_ayaka.yaml'
import __keqing__ from '../data/character/keqing.yaml'
import __klee__ from '../data/character/klee.yaml'
import __kujou_sara__ from '../data/character/kujou_sara.yaml'
import __lisa__ from '../data/character/lisa.yaml'
import __mona__ from '../data/character/mona.yaml'
import __ningguang__ from '../data/character/ningguang.yaml'
import __noelle__ from '../data/character/noelle.yaml'
import __qiqi__ from '../data/character/qiqi.yaml'
import __raiden_shogun__ from '../data/character/raiden_shogun.yaml'
import __rezor__ from '../data/character/rezor.yaml'
import __rosaria__ from '../data/character/rosaria.yaml'
import __sangonomiya_kokomi__ from '../data/character/sangonomiya_kokomi.yaml'
import __sayu__ from '../data/character/sayu.yaml'
import __shenhe__ from '../data/character/shenhe.yaml'
import __sucrose__ from '../data/character/sucrose.yaml'
import __tartaglia__ from '../data/character/tartaglia.yaml'
import __thoma__ from '../data/character/thoma.yaml'
import __traveler__ from '../data/character/traveler.yaml'
import __venti__ from '../data/character/venti.yaml'
import __xiangling__ from '../data/character/xiangling.yaml'
import __xiao__ from '../data/character/xiao.yaml'
import __xingqiu__ from '../data/character/xingqiu.yaml'
import __xinyan__ from '../data/character/xinyan.yaml'
import __yanfei__ from '../data/character/yanfei.yaml'
import __yoimiya__ from '../data/character/yoimiya.yaml'
import __yun_jin__ from '../data/character/yun_jin.yaml'
import __zhongli__ from '../data/character/zhongli.yaml'

# function
class CharacterX

  data: {}

  # ---

  constructor: ->

    data = {}
    $.mixin data, albedo: __albedo__
    $.mixin data, aloy: __aloy__
    $.mixin data, amber: __amber__
    $.mixin data, arataki_itto: __arataki_itto__
    $.mixin data, barbara: __barbara__
    $.mixin data, beidou: __beidou__
    $.mixin data, bennett: __bennett__
    $.mixin data, chongyun: __chongyun__
    $.mixin data, diluc: __diluc__
    $.mixin data, diona: __diona__
    $.mixin data, eula: __eula__
    $.mixin data, fischl: __fischl__
    $.mixin data, ganyu: __ganyu__
    $.mixin data, gorou: __gorou__
    $.mixin data, hu_tao: __hu_tao__
    $.mixin data, jean: __jean__
    $.mixin data, kaedehara_kazuha: __kaedehara_kazuha__
    $.mixin data, kaeya: __kaeya__
    $.mixin data, kamisato_ayaka: __kamisato_ayaka__
    $.mixin data, keqing: __keqing__
    $.mixin data, klee: __klee__
    $.mixin data, kujou_sara: __kujou_sara__
    $.mixin data, lisa: __lisa__
    $.mixin data, mona: __mona__
    $.mixin data, ningguang: __ningguang__
    $.mixin data, noelle: __noelle__
    $.mixin data, qiqi: __qiqi__
    $.mixin data, raiden_shogun: __raiden_shogun__
    $.mixin data, rezor: __rezor__
    $.mixin data, rosaria: __rosaria__
    $.mixin data, sangonomiya_kokomi: __sangonomiya_kokomi__
    $.mixin data, sayu: __sayu__
    $.mixin data, shenhe: __shenhe__
    $.mixin data, sucrose: __sucrose__
    $.mixin data, tartaglia: __tartaglia__
    $.mixin data, thoma: __thoma__
    $.mixin data, traveler: __traveler__
    $.mixin data, venti: __venti__
    $.mixin data, xiangling: __xiangling__
    $.mixin data, xiao: __xiao__
    $.mixin data, xingqiu: __xingqiu__
    $.mixin data, xinyan: __xinyan__
    $.mixin data, yanfei: __yanfei__
    $.mixin data, yoimiya: __yoimiya__
    $.mixin data, yun_jin: __yun_jin__
    $.mixin data, zhongli: __zhongli__

    for key, char of data

      @data[key] =
        cdE: @padArray @makeValueIntoArray char['cd-e']
        cdQ: char['cd-q']
        color: @makeValueIntoArray char['color']
        durationE: @padArray @makeValueIntoArray char['duration-e']
        durationQ: char['duration-q']
        name: char['name']
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

    value = Config.read "#{$.toLowerCase @data[key].name}/#{name}", 0
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