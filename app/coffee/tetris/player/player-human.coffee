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
      moveLeft: @game.input.keyboard.addKey @config.keys.moveLeft, @
      moveRight: @game.input.keyboard.addKey @config.keys.moveRight, @
      rotateLeft: @game.input.keyboard.addKey @config.keys.rotateLeft, @
      rotateRight: @game.input.keyboard.addKey @config.keys.rotateRight, @
      finish: @game.input.keyboard.addKey @config.keys.finish, @
      accelerate: @game.input.keyboard.addKey @config.keys.accelerate, @

    @keys.moveLeft.onDown.add @moveLeft, @
    @keys.moveRight.onDown.add @moveRight, @
    @keys.rotateLeft.onDown.add @rotateLeft, @
    @keys.rotateRight.onDown.add @rotateRight, @


module.exports = PlayerHuman
