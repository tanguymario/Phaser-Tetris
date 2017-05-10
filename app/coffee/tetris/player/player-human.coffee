Player = require './player.coffee'
PlayerHumanConfig = require './player-human-config.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class PlayerHuman extends Player
  constructor: (game, gridTheme, sounds, playerConfig) ->
    super game, gridTheme, sounds

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
    @keys.accelerate.onDown.add @startAccelerate, @
    @keys.accelerate.onUp.add @endAccelerate, @
    @keys.finish.onDown.add @finish, @

    if @game.input.gamepad.supported
      pad = @game.input.gamepad
      pad.start()
      pad.onDownCallback = @gamepadOnDownHandler
      pad.onUpCallback = @gamepadOnUpHandler


  gamepadOnUpHandler: (button) =>
    switch button
      when @config.gamepad.accelerate then @endAccelerate()


  gamepadOnDownHandler: (button) =>
    switch button
      when @config.gamepad.moveLeft then @moveLeft()
      when @config.gamepad.moveRight then @moveRight()
      when @config.gamepad.rotateLeft then @rotateLeft()
      when @config.gamepad.rotateRight then @rotateRight()
      when @config.gamepad.accelerate then @startAccelerate()
      when @config.gamepad.finish then @finish()


module.exports = PlayerHuman
