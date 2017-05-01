Grid = require './grid/grid.coffee'
GridConfig = require './grid/grid-config.coffee'

Rectangle = require '../utils/geometry/rectangle.coffee'

assert = require '../utils/assert.coffee'

debug       = require '../utils/debug.coffee'
debugThemes = require '../utils/debug-themes.coffee'

class Tetris

  @NB_MIN_PLAYERS = 1
  @NB_MAX_PLAYERS = Infinity

  constructor: (game, players..., gridConfig) ->
    assert game?, "Game missing"
    assert players.length >= Tetris.NB_MIN_PLAYERS, "Not enough players"
    assert players.length <= Tetris.NB_MAX_PLAYERS, "Too Much players"

    @game = game
    @players = players

    gameMaxSize = Math.min @game.width, @game.height

    caseColumnMax = gameMaxSize / gridConfig.size.w
    caseLineMax = gameMaxSize / gridConfig.size.h
    caseMaxSize = Math.min caseColumnMax, caseLineMax

    gridWidth = caseMaxSize * gridConfig.w
    gridHeight = caseMaxSize * gridConfig.h

    topLeftX = @game.world.centerX - gridWidth / 2
    topLeftY = @game.world.centerY - gridHeight / 2
    topLeft = new Coordinates topLeftX, topLeftY

    # Grid creation (one player = one grid)
    for i in [0..@players.length - 1] by 1
      player = players[i]

      # TODO
      rect = new Rectangle


      player.grid = new Grid @game,


module.exports = Tetris
