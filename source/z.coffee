import 'include/head.ahk'
import 'include/shell-ahk'

$ = $

$.on 'l-button', ->
  $.click 'right:down'
  $.setTimeout ->
    $.click 'right:up'
  , 1e3