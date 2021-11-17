### interface
type Fn = () => unknown
###

# variable
timer.beep = 0

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

    $.clearInterval timer.beep
    timer.beep = $.setInterval =>
      $.beep()
      @index++
      if @index >= n
        $.clearInterval timer.beep
        if callback then callback()
    , 200

  # play(name: string): void
  play: (name) -> $.play "audio/#{name}"

# execute
sound = new SoundX()