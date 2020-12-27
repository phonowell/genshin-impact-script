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

config = new ConfigX()

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
  $.on key, (key = key) -> startToggle key
  $.on "#{key}:up", (key = key) -> stopToggle key

if config.data.easySkillTimer
  $.on 'e', -> $.press 'e:down'
  $.on 'e:up', ->
    $.press 'e:up'
    countDown 5e3

if config.data.fastPaimonMenu
  paimon.bindEvent()

if config.data.fastPick
  $.on 'f', startPick
  $.on 'f:up', stopPick

# attack

if config.data.improvedAttack
  $.on 'l-button', startAttack
  $.on 'l-button:up', stopAttack

if config.data.improvedElementalVision
  $.on 'm-button', toggleView

if config.data.improvedJump
  $.on 'space', jump
  $.on 'x', ->
    $.press 'x'
    $.press 'space'

# sprint

$.on 'r-button', startDash
$.on 'r-button:up', stopDash

if config.data.improvedSprint

  $.on 'w', -> $.press 'w:down'
  $.on 'w:up', ->
    if state.isDashing then return
    $.press 'w:up'