# @ts-check

class UtilityG

  ###* @type import('./type/utility').UtilityG['makeList'] ###
  makeList: (_type, list) ->
    if list then return list
    return []

# @ts-ignore
Utility = new UtilityG()