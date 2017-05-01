Coordinates = require '../../utils/coordinates.coffee'

Direction = require '../../utils/direction.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class Case

  @S_NONE = 0
  @S_CYAN = 1
  @S_YELLOW = 2
  @S_GREEN = 3
  @S_RED = 4
  @S_BLUE = 5
  @S_PURPLE = 6
  @S_ORANGE = 7

  constructor: (game, grid, gridCoords, theme) ->
    assert gridCoords instanceof Coordinates, "GridCoords missing"

    @game = game
    @grid = grid
    @coords = gridCoords
    @theme = theme

    @sprite = @game.add.sprite 0, 0, @theme.key, Case.S_NONE


  getCaseAt: (direction) ->
    assert direction instanceof Direction, "direction missing"

    neighbourCoords = Coordinates.Add @coords, direction.value
    return @grid.getCaseAtGridCoords neighbourCoords


module.exports = Case
