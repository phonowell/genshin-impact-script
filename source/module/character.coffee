import __character_a_m__ from '../../data/character-a-m.yaml'
import __character_n_z__ from '../../data/character-n-z.yaml'

class CharacterX

  data: $.mixin __character_a_m__, __character_n_z__

  constructor: ->

    for name, char of @data

      # backend

      # cd

      unless char.cd
        char.cd = [0, 0]

      if $.isNumber char.cd
        char.cd = [char.cd, char.cd]

      # color

      # delayJump

      # duration

      unless char.duration
        char.duration = [0, 0]

      if $.isNumber char.duration
        char.duration = [char.duration, char.duration]

      # tactic
      tactic = Config.read "#{name}/tactic", 0
      if tactic
        tactic = $.replace tactic, ' ', ''
        listAll = []
        for group in $.split tactic, ';'
          listGroup = []
          for item in $.split group, ','
            $.push listGroup, item
          $.push listAll, listGroup
        char.tactic = listAll

      # type-apr
      char.typeApr = Config.read "#{name}/type-apr", 0

      # type-e
      unless char.typeE
        char.typeE = 0

# execute
Character = new CharacterX()