class EmitterX

  bus: []

  emit: (key, args...) ->
    [type, name] = $.split key, '.'

    unless type
      return @

    unless name
      for item in @bus
        unless item[0] == type
          continue
        item[2] args...
      return @

    for item in @bus
      unless item[0] == type and item[1] == name
        continue
      item[2] args...
    return @

  off: (key) ->
    [type, name] = $.split key, '.'

    unless type
      @bus = []
      return @

    unless name
      busNew = []
      for item in @bus
        if item[0] == type
          continue
        busNew.Push item
      @bus = busNew
      return @

    busNew = []
    for item in @bus
      if item[0] == type and item[1] == name
        continue
      busNew.Push item
    @bus = busNew
    return @

  on: (key, callback) ->
    [type, name] = $.split key, '.'
    @bus.Push [type, name, callback]
    return @