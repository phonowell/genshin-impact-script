class CharacterX

  source: 'character.ini'

  # ---

  constructor: ->

    @index = $.split (@read 'index/index'), ','

    for name in @index
      @[name] =
        cd: $.split (@read "#{name}/cd", '0,0'), ','
        color: @read "#{name}/color", 0
        typeApr: @read "#{name}/type-apr", 1
        typeAtk: @read "#{name}/type-atk", 1
        typeE: @read "#{name}/type-e", 0

  read: (key, defaultValue = '') ->
    [__section__, __key__] = $.split key, '/'
    `IniRead, __result__, % this.source, % __section__, % __key__, % defaultValue`
    return __result__

# execute

Character = new CharacterX()