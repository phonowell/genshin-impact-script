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

if config.data.autoESkill
  for key in ['1', '2', '3', '4', '5']
    $.on key, (key = key) -> startToggle key
    $.on "#{key}:up", stopToggle

if config.data.backJump

  $.on 's', ->
    $.press 's:down'
    startJumpBack()

  $.on 's:up', ->
    $.press 's:up'
    stopJumpBack()

if config.data.easySkillTimer
  $.on 'e', -> $.press 'e:down'
  $.on 'e:up', ->
    $.press 'e:up'
    countDown 5e3

if config.data.fastPaimonMenu
  paimon.bind()

if config.data.fastPick
  $.on 'f', startPick
  $.on 'f:up', stopPick

if config.data.fastWing
  $.on 'space', $.throttle 500, jumpTwice

if config.data.improvedElementalVision
  $.on 'mbutton', toggleView

if config.data.improvedSprint

  $.on 'rbutton', startDash
  $.on 'rbutton:up', stopDash

  $.on 'w', -> $.press 'w:down'
  $.on 'w:up', ->
    if state.isDashing then return
    $.press 'w:up'