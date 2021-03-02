import __character__ from '../../data/character.yaml'

class CharacterX

  data: __character__

  constructor: ->

    for name, char of @data

      # cd

      unless char.cd
        char.cd = [0, 0]

      if ($.type char.cd) == 'number'
        char.cd = [char.cd, char.cd]

      # color

      # type-apr
      char.typeApr = Config.read "#{name}/type-apr", 1

      # type-atk
      char.typeAtk = Config.read "#{name}/type-atk", 1

      # type-e
      unless char.typeE
        char.typeE = 0

# execute
Character = new CharacterX()