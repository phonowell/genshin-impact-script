import 'include/head.ahk'
import 'include/js-shim.ahk'

$ = $
clearInterval = clearInterval
clearTimeout = clearTimeout
setInterval = setInterval
setTimeout = setTimeout

$.on 'l-button', ->
  $.click 'right:down'
  setTimeout ->
    $.click 'right:up'
  , 1e3