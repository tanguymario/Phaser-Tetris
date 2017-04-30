Phaser = require 'Phaser'

config      = require '../config/config.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Game extends Phaser.State
  constructor: ->
    debug 'Constructor...', @, 'info', 30, debugThemes.Phaser
    super


  preload: ->
    debug 'Preload...', @, 'info', 30, debugThemes.Phaser


  create: ->
    debug 'Create...', @, 'info', 30, debugThemes.Phaser


  toggleFullscreen: ->
    if @game.scale.isFullScreen
      @game.scale.stopFullScreen()
    else
      @game.scale.startFullScreen()


module.exports = Game
