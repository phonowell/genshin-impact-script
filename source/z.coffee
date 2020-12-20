# include include/head.ahk
# include include/js-shim.ahk

$.on 'f11', -> $.info $.getColor()

$.on 'f12', -> alert "#{A_GuiWidth} x #{A_GuiHeight}"