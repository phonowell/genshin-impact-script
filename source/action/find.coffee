# execute

if config.data.betterElementalVision
  player.on 'find-end', -> $.delay 200, ->
    $.press 'm'
