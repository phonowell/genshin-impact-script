import '../../gis-static/lib/ShiftAppVolume.ahk'

### interface
type Fn = () => unknown
###

# function
class Sound

  index: 0

  constructor: ->
    Client.on 'pause', -> ShiftAppVolumeTopped Config.data.process, 0
    Client.on 'resume', -> ShiftAppVolumeTopped Config.data.process, 1
    ShiftAppVolumeTopped Config.data.process, 1

  # beep(n: number = 1, callback: Fn): void
  beep: (n = 1, callback = '') ->

    $.beep()

    if n == 1
      if callback then callback()
      return
    @index = 1

    Timer.loop 'sound/beep', 200, =>
      $.beep()
      @index++
      if @index >= n
        Timer.remove 'sound/beep'
        if callback then callback()
    , 200

  # play(name: string): void
  play: (name) -> $.play "audio/#{name}"

# execute
Sound = new Sound()