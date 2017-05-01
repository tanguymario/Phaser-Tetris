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

    # TODO one player only for now
    topLeftGame = new Coordinates 0, 0
    gameRectangle = new Rectangle topLeftGame, @game.width, @game.height

    # Grid creation (one player = one grid)
    for i in [0..@players.length - 1] by 1
      player = players[i]
      player.grid = new Grid @game, gameRectangle, gridConfig, player.theme
      

module.exports = Tetris
