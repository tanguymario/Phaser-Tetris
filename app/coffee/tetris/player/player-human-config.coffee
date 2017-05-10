Phaser = require 'Phaser'

Enum = require 'enum'

module.exports =
  player1:
    gamepad:
      moveLeft: Phaser.Gamepad.XBOX360_DPAD_LEFT
      moveRight: Phaser.Gamepad.XBOX360_DPAD_RIGHT
      rotateLeft: Phaser.Gamepad.XBOX360_A
      rotateRight: Phaser.Gamepad.XBOX360_B
      finish: Phaser.Gamepad.XBOX360_DPAD_UP
      accelerate: Phaser.Gamepad.XBOX360_DPAD_DOWN
    keys:
      moveLeft: Phaser.Keyboard.Q
      moveRight: Phaser.Keyboard.D
      rotateLeft: Phaser.Keyboard.Z
      rotateRight: Phaser.Keyboard.S
      finish: Phaser.Keyboard.Z
      accelerate: Phaser.Keyboard.S
  player2:
    gamepad:
      moveLeft: Phaser.Gamepad.XBOX360_DPAD_LEFT
      moveRight: Phaser.Gamepad.XBOX360_DPAD_RIGHT
      rotateLeft: Phaser.Gamepad.XBOX360_A
      rotateRight: Phaser.Gamepad.XBOX360_B
      finish: Phaser.Gamepad.XBOX360_DPAD_UP
      accelerate: Phaser.Gamepad.XBOX360_DPAD_DOWN
    keys:
      moveLeft: Phaser.Keyboard.LEFT
      moveRight: Phaser.Keyboard.RIGHT
      rotateLeft: Phaser.Keyboard.L
      rotateRight: Phaser.Keyboard.M
      finish: Phaser.Keyboard.SPACE
      accelerate: Phaser.Keyboard.DOWN
