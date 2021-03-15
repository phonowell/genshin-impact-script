$$ = {}

# validate type
$$.vt = (name, target, type...) ->

  _type = $.type target

  unless $.includes type, _type
    throw new Error "#{name}: invalid type '#{_type}', should be '#{$.toString type}'"