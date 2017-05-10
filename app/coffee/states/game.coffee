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
    @playerSounds = PlayerSounds.classic

    @sounds =
      music:
        key: 'music-a-prehistoric-tale'
        src: 'assets/snd/songs/A_Prehistoric_Tale.ogg'
        volumne: 1
      gameOver:
        key: 'game-over'
        src: 'assets/snd/songs/Jingle_Lose_00.mp3'
        volume: 1

    @background =
      key: 'background-classic'
      src: 'assets/img/tetris/backgrounds/classic.jpg'


  preload: ->
    debug 'Preload...', @, 'info', 30, debugThemes.Phaser

    # Images
    @game.load.image @background.key, @background.src
    @game.load.spritesheet @theme.key, @theme.src, @theme.spriteSize.w, @theme.spriteSize.h

    # Snd - Song
    for soundKey, soundValue of @sounds
      @game.load.audio soundValue.key, soundValue.src

    # Snd - Effects
    for soundKey, soundValue of @playerSounds
      soundValue.audio = @game.load.audio soundValue.key, soundValue.src


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
    pad3 = @game.input.gamepad.pad3
    pad4 = @game.input.gamepad.pad4

    # Create tetris game
    player1 = new PlayerHuman @game, @theme, @playerSounds, PlayerHumanConfig.player1, pad1
    player2 = new PlayerHuman @game, @theme, @playerSounds, PlayerHumanConfig.player2, pad2
    player3 = new PlayerHuman @game, @theme, @playerSounds, PlayerHumanConfig.player2, pad2
    player4 = new PlayerHuman @game, @theme, @playerSounds, PlayerHumanConfig.player2, pad2

    tetrisGame = new Tetris @game, GridConfig.classic, @sounds, player1, player2, player3, player4


  toggleFullscreen: ->
    if @game.scale.isFullScreen
      @game.scale.stopFullScreen()
    else
      @game.scale.startFullScreen false


module.exports = Game
