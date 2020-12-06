# include include/admin.ahk
# include include/head.ahk
# include include/js-shim.ahk

# variable

state = {}
timer = {}
ts = {}

# include module/*
# include skill/*

# execute

client = new ClientX()
client.watch()
paimon = new PaimonX()

# binding

$.on 'alt + f4', ->
  $.beep()
  client.reset()
  $.exit()

$.on 'ctrl + f5', ->
  $.beep()
  client.reset()
  $.reload()

# binding

for key in ['1', '2', '3', '4', '5']
  $.on key, (key = key) -> toggle key

paimon.bind()

$.on 'e', -> $.press 'e:down'
$.on 'e:up', ->
  $.press 'e:up'
  countDown 5e3

$.on 'f', startPick
$.on 'f:up', stopPick

$.on 'mbutton', toggleView

$.on 'rbutton', startDash
$.on 'rbutton:up', stopDash

$.on 's', ->
  $.press 's:down'
  startJumpBack()

$.on 's:up', ->
  $.press 's:up'
  stopJumpBack()

$.on 'space', $.throttle 500, jumpTwice

$.on 'w', -> $.press 'w:down'
$.on 'w:up', ->
  if state.isDashing then return
  $.press 'w:up'