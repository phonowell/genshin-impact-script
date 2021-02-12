class EmitterX

  busEvent: []

  # ---

  emit: (name, args...) -> for item in @busEvent

    [_name, callback] = item

    unless _name == name
      continue

    callback args...

  on: (name, callback) -> @busEvent.Push [name, callback]