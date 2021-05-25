import 'include/head.ahk'
import 'include/shell-ahk'

$ = $

$.on 'f12', ->
  $.beep()
  $.setFixed()