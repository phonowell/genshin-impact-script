# @ts-check

import __albedo__ from '../../genshin-character-data/source/albedo.yaml'
import __aloy__ from '../../genshin-character-data/source/aloy.yaml'
import __amber__ from '../../genshin-character-data/source/amber.yaml'
import __arataki_itto__ from '../../genshin-character-data/source/arataki_itto.yaml'
import __barbara__ from '../../genshin-character-data/source/barbara.yaml'
import __beidou__ from '../../genshin-character-data/source/beidou.yaml'
import __bennett__ from '../../genshin-character-data/source/bennett.yaml'
import __candace__ from '../../genshin-character-data/source/candace.yaml'
import __chongyun__ from '../../genshin-character-data/source/chongyun.yaml'
import __collei__ from '../../genshin-character-data/source/collei.yaml'
import __cyno__ from '../../genshin-character-data/source/cyno.yaml'
import __diluc__ from '../../genshin-character-data/source/diluc.yaml'
import __diona__ from '../../genshin-character-data/source/diona.yaml'
import __dori__ from '../../genshin-character-data/source/dori.yaml'
import __eula__ from '../../genshin-character-data/source/eula.yaml'
import __fischl__ from '../../genshin-character-data/source/fischl.yaml'
import __ganyu__ from '../../genshin-character-data/source/ganyu.yaml'
import __gorou__ from '../../genshin-character-data/source/gorou.yaml'
import __hu_tao__ from '../../genshin-character-data/source/hu_tao.yaml'
import __jean__ from '../../genshin-character-data/source/jean.yaml'
import __kaedehara_kazuha__ from '../../genshin-character-data/source/kaedehara_kazuha.yaml'
import __kaeya__ from '../../genshin-character-data/source/kaeya.yaml'
import __kamisato_ayaka__ from '../../genshin-character-data/source/kamisato_ayaka.yaml'
import __kamisato_ayato__ from '../../genshin-character-data/source/kamisato_ayato.yaml'
import __keqing__ from '../../genshin-character-data/source/keqing.yaml'
import __klee__ from '../../genshin-character-data/source/klee.yaml'
import __kujou_sara__ from '../../genshin-character-data/source/kujou_sara.yaml'
import __kuki_shinobu__ from '../../genshin-character-data/source/kuki_shinobu.yaml'
import __lisa__ from '../../genshin-character-data/source/lisa.yaml'
import __mona__ from '../../genshin-character-data/source/mona.yaml'
import __nahida__ from '../../genshin-character-data/source/nahida.yaml'
import __nilou__ from '../../genshin-character-data/source/nilou.yaml'
import __ningguang__ from '../../genshin-character-data/source/ningguang.yaml'
import __noelle__ from '../../genshin-character-data/source/noelle.yaml'
import __qiqi__ from '../../genshin-character-data/source/qiqi.yaml'
import __raiden_shogun__ from '../../genshin-character-data/source/raiden_shogun.yaml'
import __rezor__ from '../../genshin-character-data/source/rezor.yaml'
import __rosaria__ from '../../genshin-character-data/source/rosaria.yaml'
import __sangonomiya_kokomi__ from '../../genshin-character-data/source/sangonomiya_kokomi.yaml'
import __sayu__ from '../../genshin-character-data/source/sayu.yaml'
import __shenhe__ from '../../genshin-character-data/source/shenhe.yaml'
import __shikanoin_heizou__ from '../../genshin-character-data/source/shikanoin_heizou.yaml'
import __sucrose__ from '../../genshin-character-data/source/sucrose.yaml'
import __tartaglia__ from '../../genshin-character-data/source/tartaglia.yaml'
import __thoma__ from '../../genshin-character-data/source/thoma.yaml'
import __tighnari__ from '../../genshin-character-data/source/tighnari.yaml'
import __traveler__ from '../../genshin-character-data/source/traveler.yaml'
import __venti__ from '../../genshin-character-data/source/venti.yaml'
import __xiangling__ from '../../genshin-character-data/source/xiangling.yaml'
import __xiao__ from '../../genshin-character-data/source/xiao.yaml'
import __xingqiu__ from '../../genshin-character-data/source/xingqiu.yaml'
import __xinyan__ from '../../genshin-character-data/source/xinyan.yaml'
import __yae_miko__ from '../../genshin-character-data/source/yae_miko.yaml'
import __yanfei__ from '../../genshin-character-data/source/yanfei.yaml'
import __yelan__ from '../../genshin-character-data/source/yelan.yaml'
import __yoimiya__ from '../../genshin-character-data/source/yoimiya.yaml'
import __yun_jin__ from '../../genshin-character-data/source/yun_jin.yaml'
import __zhongli__ from '../../genshin-character-data/source/zhongli.yaml'

class CharacterG

  constructor: ->

    ###* @type import('./type/character').CharacterG['data'] ###
    @data = {}
    ###* @type import('./type/character').CharacterG['source'] ###
    @source = 'character.ini'

  ###* @type import('./type/character').CharacterG['get'] ###
  get: (name, key = undefined) ->
    unless name then return ''
    unless key then return @data[name]
    return @data[name][key]

  ###* @type import('./type/character').CharacterG['init'] ###
  init: -> @load()

  ###* @type import('./type/character').CharacterG['isTuple'] ###
  isTuple: (ipt) -> ($.length ipt) == 2

  ###* @type import('./type/character').CharacterG['load'] ###
  load: ->

    ###* @type import('./type/character').dataRaw ###
    data = {}

    $.mixin data, albedo: __albedo__
    $.mixin data, aloy: __aloy__
    $.mixin data, amber: __amber__
    $.mixin data, arataki_itto: __arataki_itto__
    $.mixin data, barbara: __barbara__
    $.mixin data, beidou: __beidou__
    $.mixin data, bennett: __bennett__
    $.mixin data, candace: __candace__
    $.mixin data, chongyun: __chongyun__
    $.mixin data, collei: __collei__
    $.mixin data, cyno: __cyno__
    $.mixin data, diluc: __diluc__
    $.mixin data, diona: __diona__
    $.mixin data, dori: __dori__
    $.mixin data, eula: __eula__
    $.mixin data, fischl: __fischl__
    $.mixin data, ganyu: __ganyu__
    $.mixin data, gorou: __gorou__
    $.mixin data, hu_tao: __hu_tao__
    $.mixin data, jean: __jean__
    $.mixin data, kaedehara_kazuha: __kaedehara_kazuha__
    $.mixin data, kaeya: __kaeya__
    $.mixin data, kamisato_ayaka: __kamisato_ayaka__
    $.mixin data, kamisato_ayato: __kamisato_ayato__
    $.mixin data, keqing: __keqing__
    $.mixin data, klee: __klee__
    $.mixin data, kujou_sara: __kujou_sara__
    $.mixin data, kuki_shinobu: __kuki_shinobu__
    $.mixin data, lisa: __lisa__
    $.mixin data, mona: __mona__
    $.mixin data, nahida: __nahida__
    $.mixin data, nilou: __nilou__
    $.mixin data, ningguang: __ningguang__
    $.mixin data, noelle: __noelle__
    $.mixin data, qiqi: __qiqi__
    $.mixin data, raiden_shogun: __raiden_shogun__
    $.mixin data, rezor: __rezor__
    $.mixin data, rosaria: __rosaria__
    $.mixin data, sangonomiya_kokomi: __sangonomiya_kokomi__
    $.mixin data, sayu: __sayu__
    $.mixin data, shenhe: __shenhe__
    $.mixin data, shikanoin_heizou: __shikanoin_heizou__
    $.mixin data, sucrose: __sucrose__
    $.mixin data, tartaglia: __tartaglia__
    $.mixin data, thoma: __thoma__
    $.mixin data, tighnari: __tighnari__
    $.mixin data, traveler: __traveler__
    $.mixin data, venti: __venti__
    $.mixin data, xiangling: __xiangling__
    $.mixin data, xiao: __xiao__
    $.mixin data, xingqiu: __xingqiu__
    $.mixin data, xinyan: __xinyan__
    $.mixin data, yae_miko: __yae_miko__
    $.mixin data, yanfei: __yanfei__
    $.mixin data, yelan: __yelan__
    $.mixin data, yoimiya: __yoimiya__
    $.mixin data, yun_jin: __yun_jin__
    $.mixin data, zhongli: __zhongli__

    for name, char of data

      @data[name] =
        cdE: @padArray @makeValueIntoArray char['cd-e']
        cdQ: char['cd-q']
        color: char['color']
        constellation: 0
        durationE: @padArray @makeValueIntoArray char['duration-e']
        durationQ: char['duration-q']
        onLongPress: ''
        onSideButton1: ''
        onSideButton2: ''
        onSwitch: ''
        star: char['star']
        typeE: char['type-e']
        typeSprint: char['type-sprint']
        vision: char.vision
        weapon: char.weapon

      @data[name].constellation = $.toNumber @pickFromFile name, 'constellation'
      @data[name].onLongPress = $.toString @pickFromFile name, 'on-long-press'
      @data[name].onSideButton1 = $.toString @pickFromFile name, 'on-side-button-1'
      @data[name].onSideButton2 = $.toString @pickFromFile name, 'on-side-button-2'
      @data[name].onSwitch = $.toString @pickFromFile name, 'on-switch'

      if name == 'traveler'
        @data[name].vision = $.toString @pickFromFile name, 'vision'
    return

  ###* @type import('./type/character').CharacterG['makeValueIntoArray'] ###
  makeValueIntoArray: (value) ->
    if $.isNumber value then return [value]
    if $.isArray value then return value
    return [0]

  ###* @type import('./type/character').CharacterG['padArray'] ###
  padArray: (list) ->
    if @isTuple list then return list
    return [list[0], list[0]]

  ###* @type import('./type/character').CharacterG['pickFromFile'] ###
  pickFromFile: (name, key) ->

    # like hu_tao
    target = @read name
    if target then return @read "#{name}/#{key}", 0

    # like hu tao
    nameDict = $.toLowerCase Dictionary.data[name][0]
    target = @read nameDict
    if target then return @read "#{nameDict}/#{key}", 0

    # like 胡桃
    if A_language == '0804'
      nameDict = $.toLowerCase Dictionary.get name
      target = @read nameDict
      if target then return @read "#{nameDict}/#{key}", 0

    # weapon
    target = @read @data[name].weapon
    if target then return @read "#{@data[name].weapon}/#{key}", 0

    # all
    target = @read 'all'
    if target then return @read "all/#{key}", 0

    return 0

  # read(ipt: string, defaultValue?: string): string
  ###* @type import('./type/character').CharacterG['read'] ###
  read: (ipt, defaultValue = '') ->
    [section, key] = $.split ipt, '/'
    result = ''
    $.noop result, section, key, defaultValue
    if key then Native 'IniRead, result, % this.source, % section, % key, % defaultValue'
    else Native 'IniRead, result, % this.source, % section'
    return $.toLowerCase result

Character = new CharacterG()