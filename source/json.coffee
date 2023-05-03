# @ts-check

import './lib/Jxon.ahk'

class JsonG

  ###* @type import('./type/json').JsonG['read'] ###
  read: (path) ->
    f = $.file path
    content = f.read()
    return Jxon_Load content

# @ts-ignore
Json2 = new JsonG()