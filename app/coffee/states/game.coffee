Phaser = require 'Phaser'

GridConfig = require '../tetris/grid/grid-config.coffee'
GridTheme = require '../tetris/grid/grid-theme.coffee'

PlayerHuman = require '../tetris/player/player-human.coffee'
PlayerHumanConfig = require '../tetris/player/player-human-config.coffee'
PlayerAI = require '../tetris/player/player-ai.coffee'

Tetris = require '../tetris/tetris.coffee'

config      = require '../config/config.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Game extends Phaser.State
  constructor: ->
    debug 'Constructor...', @, 'info', 30, debugThemes.Phaser
    super


  preload: ->
    debug 'Preload...', @, 'info', 30, debugThemes.Phaser

    # TODO - to change
    @theme = GridTheme.debug

    @game.load.spritesheet @theme.key, @theme.src, @theme.spriteSize.w, @theme.spriteSize.h


  create: ->
    debug 'Create...', @, 'info', 30, debugThemes.Phaser

    player1 = new PlayerHuman @game, @theme, PlayerHumanConfig.player2
    tetrisGame = new Tetris @game, GridConfig.classic, player1


  toggleFullscreen: ->
    if @game.scale.isFullScreen
      @game.scale.stopFullScreen()
    else
      @game.scale.startFullScreen()


module.exports = Game
