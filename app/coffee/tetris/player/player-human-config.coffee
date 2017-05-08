Phaser = require 'Phaser'

module.exports =
  player1:
    keys:
      moveLeft: Phaser.Keyboard.Q
      moveRight: Phaser.Keyboard.D
      rotateLeft: Phaser.Keyboard.Z
      rotateRight: Phaser.Keyboard.S
      finish: Phaser.Keyboard.Z
      accelerate: Phaser.Keyboard.S
  player2:
    keys:
      moveLeft: Phaser.Keyboard.LEFT
      moveRight: Phaser.Keyboard.RIGHT
      rotateLeft: Phaser.Keyboard.UP
      rotateRight: Phaser.Keyboard.DOWN
      finish: Phaser.Keyboard.UP
      accelerate: Phaser.Keyboard.DOWN
