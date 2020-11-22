# include include/head.ahk
# include include/js-shim.ahk

isPressing = (key) -> return ($.getState key) == 'D'

$.on 'f1', -> alert $.getState 'f1'