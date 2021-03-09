import 'include/admin.ahk'
import 'include/head.ahk'
import 'shell-ahk'

# declare

$ = $

# variable

state = {}
timer = {}
ts = {}

import 'module'
import 'action/*'
import 'tactic'

# binding

$.on 'alt + f4', ->
  $.beep()
  client.reset()
  $.exit()

$.on 'ctrl + f5', ->
  $.beep()
  client.reset()
  $.reload()