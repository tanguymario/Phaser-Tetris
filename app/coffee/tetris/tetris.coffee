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

  constructor: (game, gridConfig, players...) ->
    assert game?, "Game missing"
    assert players.length >= Tetris.NB_MIN_PLAYERS, "Not enough players"
    assert players.length <= Tetris.NB_MAX_PLAYERS, "Too Much players"

    @game = game
    @players = players
    @gridConfig = gridConfig

    layoutStepX = @game.width / @players.length
    leftPoint = new Coordinates 0, 0

    # Grid creation (one player = one grid)
    for i in [0...@players.length] by 1
      player = players[i]
      gameRectangle = new Rectangle leftPoint, layoutStepX, @game.height
      player.grid = new Grid @game, gameRectangle, @gridConfig, player.theme
      leftPoint.x += layoutStepX

    @timer = @game.time.events.loop 1000, @updateTetrisGame, @


  updateTetrisGame: ->
    for player in @players
      if not player.currentBlock? or player.currentBlock.fixed
        player.generateBlock()
      else
        player.currentBlock.update()


module.exports = Tetris
