$$ = {}

$$.vt = (name, target, type...) ->

  unless Config.data.isDebug
    return

  _type = $.type target

  unless $.includes type, _type
    throw new Error "#{name}: invalid type '#{_type}', should be '#{$.toString type}'"