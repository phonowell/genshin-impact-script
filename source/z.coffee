import 'include/head.ahk'
import 'include/js-shim.ahk'

$.on 'f11', -> $.info $.getColor()

$.on 'f12', -> alert "#{A_GuiWidth} x #{A_GuiHeight}"