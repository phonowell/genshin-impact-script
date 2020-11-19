# include include/admin.ahk
# include include/head.ahk
# include include/js-shim.ahk

# function

bind = ->

  for key in ['1', '2', '3', '4', '5']
    $.on key, (key = key) -> $.press key

init = ->
  $.off 'f1', init
  bind()

# binding

$.on 'f1', init