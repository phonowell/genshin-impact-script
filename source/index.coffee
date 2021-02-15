import 'include/admin.ahk'
import 'include/head.ahk'
import 'js-shim.ahk'

# declare

$ = $
clearInterval = clearInterval
clearTimeout = clearTimeout
setInterval = setInterval
setTimeout = setTimeout

# variable

state = {}
timer = {}
ts = {}

import 'module'
import 'action/*'

# binding

$.on 'alt + enter', ->
  $.press 'alt + enter'
  $.delay 1e3, client.setSize

$.on 'alt + f4', ->
  $.beep()
  client.reset()
  $.exit()

$.on 'alt + f11', ->
  $.beep()
  hud.getColor()

$.on 'ctrl + f5', ->
  $.beep()
  client.reset()
  $.reload()

$.on 'f12', member.scan