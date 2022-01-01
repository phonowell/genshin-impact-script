### interface
type Fn = () => unknown
###

# function
class SoundX

  index: 0

  # ---

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
sound = new SoundX()