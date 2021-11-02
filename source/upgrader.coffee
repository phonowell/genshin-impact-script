# function
class UpgraderX

  target: '0.0.28'

  # ---

  constructor: -> Client.delay 1e3, @main

  # confirm(text: string, callback: (data: boolean) => void): void
  confirm: (text, callback) ->
    ```
    MsgBox, 0x4,, % text`
    IfMsgBox Yes
      callback.Call(true)
    else
      callback.Call(false)
    ```

  # get(url, callback: (data: string) => void): void
  get: (url, callback) ->

    try
      whr = ComObjCreate 'WinHttp.WinHttpRequest.5.1'
      whr.Open 'GET', url, true
      whr.Send()
      whr.WaitForResponse()
      callback whr.ResponseText

    catch
      callback ''

  # main(): void
  main: ->

    url = "https://github.com/phonowell/genshin-impact-script/releases/tag/#{@target}"
    @get url, (result) =>

      unless result
        Client.delay 600e3, @main
        return

      if result == 'Not Found' then return

      msg = "Found new version: v#{@target}\nUpgrade right now?"
      if Config.data.region == 'cn'
        msg = "发现新版本：v#{@target}\n是否立刻更新？"

      @confirm msg, (answer) ->
        unless answer then return
        $.open url

# execute
Upgrader = new UpgraderX()