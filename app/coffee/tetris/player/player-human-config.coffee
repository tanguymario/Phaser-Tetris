Phaser = require 'Phaser'

module.exports =
  player1:
    keys:
      moveLeft: Phaser.Keyboard.LEFT
      moveRight: Phaser.Keyboard.RIGHT
      rotateLeft: Phaser.Keyboard.D
      rotateRight: Phaser.Keyboard.F
      finish: Phaser.Keyboard.UP
      accelerate: Phaser.Keyboard.DOWN
