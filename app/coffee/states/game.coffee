Phaser = require 'Phaser'

GridConfig = require '../tetris/grid/grid-config.coffee'
GridTheme = require '../tetris/grid/grid-theme.coffee'

PlayerHuman = require '../tetris/player/player-human.coffee'
PlayerHumanConfig = require '../tetris/player/player-human-config.coffee'
PlayerAI = require '../tetris/player/player-ai.coffee'
PlayerSounds = require '../tetris/player/player-sounds.coffee'

Coordinates = require '../utils/coordinates.coffee'

Tetris = require '../tetris/tetris.coffee'

config      = require '../config/config.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Game extends Phaser.State
  constructor: ->
    debug 'Constructor...', @, 'info', 30, debugThemes.Phaser
    super

    @theme = GridTheme.rock_semi_transparent
    @sounds = PlayerSounds.classic

    @background =
      key: 'background-classic'
      src: 'assets/img/tetris/backgrounds/classic.jpg'

    @music =
      name: 'A prehistoric tale 7'
      author: 'Madmax'
      file: 'assets/snd/songs/A_Prehistoric_Tale_7.ym'


  preload: ->
    debug 'Preload...', @, 'info', 30, debugThemes.Phaser

    # Images
    @game.load.image @background.key, @background.src
    @game.load.spritesheet @theme.key, @theme.src, @theme.spriteSize.w, @theme.spriteSize.h

    # Snd - Song
    @game.load.script 'YM', 'assets/plugins/YM.js'
    @game.load.binary @music.name, @music.file

    # Snd - Effects
    @game.load.audio @sounds.move.key, @sounds.move.src
    @game.load.audio @sounds.rotate.key, @sounds.rotate.src
    @game.load.audio @sounds.end.key, @sounds.end.src
    @game.load.audio @sounds.fixed.key, @sounds.fixed.src


  create: ->
    debug 'Create...', @, 'info', 30, debugThemes.Phaser

    # Background
    @background.sprite = @game.add.sprite 0, 0, @background.key
    bgScale = new Coordinates 0, 0
    bgScale.x = @game.width / @background.sprite.width
    bgScale.y = @game.height / @background.sprite.height
    @background.sprite.scale.setTo bgScale.x, bgScale.y

    # Fullscreen
    @game.input.onDown.add @toggleFullscreen, @

    # Pads for players
    @game.input.gamepad.start()
    pad1 = @game.input.gamepad.pad1
    pad2 = @game.input.gamepad.pad2

    # Create tetris game
    player1 = new PlayerHuman @game, @theme, @sounds, PlayerHumanConfig.player1, pad1
    player2 = new PlayerHuman @game, @theme, @sounds, PlayerHumanConfig.player2, pad2

    tetrisGame = new Tetris @game, GridConfig.classic, player1, player2

    # Start the main song
    @startSong()


  startSong: ->
    data = @game.cache.getBinary @music.name
    if not @ym
      @ym = new YM data
    else
      @ym.stop()
      @ym.clearsong()
      @ym.parse data

    @ym.play()


  toggleFullscreen: ->
    if @game.scale.isFullScreen
      @game.scale.stopFullScreen()
    else
      @game.scale.startFullScreen false


module.exports = Game
