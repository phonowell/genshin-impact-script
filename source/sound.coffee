# variable
timer.beep = 0

# function
class SoundX

  index: 0

  # ---

  # beep(n: number = 1): void
  beep: (n = 1) ->

    $.beep()

    if n == 1 then return
    @index = 1

    $.clearInterval timer.beep
    timer.beep = $.setInterval =>
      $.beep()
      @index++
      if @index >= n then $.clearInterval timer.beep
    , 200

  # play(name: string): void
  play: (name) -> $.play "audio/#{name}"

# execute
sound = new SoundX()