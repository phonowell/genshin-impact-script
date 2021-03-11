import __character__ from '../../data/character.yaml'

class CharacterX

  data: __character__

  constructor: ->

    for name, char of @data

      # cd

      unless char.cd
        char.cd = [0, 0]

      if $.isNumber char.cd
        char.cd = [char.cd, char.cd]

      # color

      # duration

      unless char.duration
        char.duration = [0, 0]

      if $.isNumber char.duration
        char.duration = [char.duration, char.duration]

      # type-apr
      char.typeApr = Config.read "#{name}/type-apr", 1

      # type-atk
      char.typeAtk = Config.read "#{name}/type-atk", 0

      # type-e
      unless char.typeE
        char.typeE = 0

# execute
Character = new CharacterX()