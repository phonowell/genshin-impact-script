$$ = {}

# validate type
$$.vt = (name, target, type) ->

  _type = $.type target

  switch $.type type
    when 'array' then listType = type
    when 'string' then listType = [type]
    else throw new Error "$$.vt/#{name}: invalid type '#{$.type type}', from '#{$.toString target}'"

  unless $.includes listType, _type
    throw new Error "#{name}: invalid type '#{_type}', should be '#{$.toString listType}'"

  return $$.vt.Bind name