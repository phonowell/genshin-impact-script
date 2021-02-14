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
import 'skill/*'

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

# binding

for key in [1, 2, 3, 4]

  $.on key, -> startToggle key
  $.on "#{key}:up", -> stopToggle key

  $.on "alt + #{key}", ->
    $.press "alt + #{key}"
    member.toggle key

if config.data.easySkillTimer
  $.on 'e', ->
    $.press 'e:down'
    skillTimer.record 'start'
  $.on 'e:up', ->
    $.press 'e:up'
    skillTimer.record 'end'

if config.data.betterElementalVision
  $.on 'm-button', toggleView