# execute

if Config.data.betterElementalVision
  player.on 'find:end', ->
    $.setTimeout ->
      $.press 'm'
    , 200
