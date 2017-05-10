Grid = require './grid/grid.coffee'
GridConfig = require './grid/grid-config.coffee'
GridLayout = require './grid/grid-layout.coffee'

Coordinates = require '../utils/coordinates.coffee'
Rectangle = require '../utils/geometry/rectangle.coffee'

assert = require '../utils/assert.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Tetris

  @NB_MIN_PLAYERS = 1
  @NB_MAX_PLAYERS = Infinity

  constructor: (game, gridConfig, sounds, players...) ->
    assert game?, "Game missing"
    assert players.length >= Tetris.NB_MIN_PLAYERS, "Not enough players"
    assert players.length <= Tetris.NB_MAX_PLAYERS, "Too Much players"

    @game = game
    @players = players
    @gridConfig = gridConfig
    @sounds = sounds
    @gameOver = false

    layoutStepX = @game.width / @players.length
    leftPoint = new Coordinates 0, 0

    # Grids creation (one player = one grid)
    @grids = new Array @players.length
    for i in [0...@players.length] by 1
      player = players[i]

      gameRectangle = new Rectangle leftPoint, layoutStepX, @game.height
      @grids[i] = new Grid @game, @, player, gameRectangle, @gridConfig

      leftPoint.x += layoutStepX

    # Start the main music
    @music = @game.add.audio @sounds.music.key
    @music.loopFull @sounds.music.volume


  # When the game is finished
  triggerEnd: ->
    @gameOver = true

    for grid in @grids
      if not grid.finished
        grid.end()

    @music.stop()

    sound = @game.add.audio @sounds.gameOver.key
    sound.play()


  # When a grid is finished
  triggerGridEnd: (grid) ->
    assert grid instanceof Grid, "Grid missing"

    if @gameOver
      return

    nbGridsFinished = 0
    for grid in @grids
      if grid.finished
        nbGridsFinished += 1

    if nbGridsFinished >= @players.length - 1
      @triggerEnd()


module.exports = Tetris
