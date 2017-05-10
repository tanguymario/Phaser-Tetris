Player = require './player.coffee'
PlayerHumanConfig = require './player-human-config.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class PlayerHuman extends Player
  @I_KEY_PAUSE = Phaser.Keyboard.P

  @I_GAMEPAD_MOVE_LEFT = Phaser.Gamepad.XBOX360_DPAD_LEFT
  @I_GAMEPAD_MOVE_RIGHT = Phaser.Gamepad.XBOX360_DPAD_RIGHT
  @I_GAMEPAD_ROTATE_LEFT = Phaser.Gamepad.XBOX360_A
  @I_GAMEPAD_ROTATE_RIGHT = Phaser.Gamepad.XBOX360_B
  @I_GAMEPAD_ACCELERATE = Phaser.Gamepad.XBOX360_DPAD_DOWN
  @I_GAMEPAD_FINISH = Phaser.Gamepad.XBOX360_DPAD_UP

  constructor: (game, gridTheme, sounds, playerConfig, gamepad = null) ->
    super game, gridTheme, sounds

    @config = playerConfig

    # Add keys
    @keys =
      moveLeft: @game.input.keyboard.addKey @config.keys.moveLeft, @
      moveRight: @game.input.keyboard.addKey @config.keys.moveRight, @
      rotateLeft: @game.input.keyboard.addKey @config.keys.rotateLeft, @
      rotateRight: @game.input.keyboard.addKey @config.keys.rotateRight, @
      finish: @game.input.keyboard.addKey @config.keys.finish, @
      accelerate: @game.input.keyboard.addKey @config.keys.accelerate, @

    # Add function called on down
    for key, keyValue of @keys
      keyValue.onDown.add @keyboardOnDownHandler, @
      keyValue.onUp.add @keyboardOnUpHandler, @

    # Add a gamepad
    if @game.input.gamepad.supported and gamepad?
      @gamepad = gamepad
      @gamepad.onDownCallback = @gamepadOnDownHandler
      @gamepad.onUpCallback = @gamepadOnUpHandler


  keyboardOnDownHandler: (key) =>
    switch key
      when @keys.moveLeft then @moveLeft()
      when @keys.moveRight then @moveRight()
      when @keys.rotateLeft then @rotateLeft()
      when @keys.rotateRight then @rotateRight()
      when @keys.accelerate then @startAccelerate()
      when @keys.finish then @finish()


  keyboardOnUpHandler: (key) =>
    switch key
      when @keys.accelerate then @endAccelerate()


  gamepadOnUpHandler: (button) =>
    switch button
      when PlayerHuman.I_GAMEPAD_ACCELERATE then @endAccelerate()


  gamepadOnDownHandler: (button) =>
    switch button
      when PlayerHuman.I_GAMEPAD_MOVE_LEFT then @moveLeft()
      when PlayerHuman.I_GAMEPAD_MOVE_RIGHT then @moveRight()
      when PlayerHuman.I_GAMEPAD_ROTATE_LEFT then @rotateLeft()
      when PlayerHuman.I_GAMEPAD_ROTATE_RIGHT then @rotateRight()
      when PlayerHuman.I_GAMEPAD_ACCELERATE then @startAccelerate()
      when PlayerHuman.I_GAMEPAD_FINISH then @finish()



module.exports = PlayerHuman
