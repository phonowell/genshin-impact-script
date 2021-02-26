# execute

if Config.data.betterElementalVision
  player.on 'find:end', -> $.delay 200, ->
    $.press 'm'
