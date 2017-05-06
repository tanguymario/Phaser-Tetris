Player = require './player.coffee'
PlayerHumanConfig = require './player-human-config.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class PlayerHuman extends Player
  constructor: (game, gridTheme, playerConfig) ->
    super game, gridTheme

    @config = playerConfig

    @keys =
      left: @game.input.keyboard.addKey @config.keys.left, @
      right: @game.input.keyboard.addKey @config.keys.right, @
      finish: @game.input.keyboard.addKey @config.keys.finish, @
      accelerate: @game.input.keyboard.addKey @config.keys.accelerate, @

    @game.input.keyboard.addKey @config.left, @
    @keys.left.onDown.add @moveLeft, @
    @keys.right.onDown.add @moveRight, @


module.exports = PlayerHuman
