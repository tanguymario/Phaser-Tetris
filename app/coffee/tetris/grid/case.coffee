Coordinates = require '../../utils/coordinates.coffee'

Direction = require '../../utils/direction.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class Case
  constructor: (game, grid, gridCoords, theme) ->
    assert gridCoords instanceof Coordinates, "GridCoords missing"

    @game = game
    @grid = grid
    @coords = gridCoords
    @theme = theme


  getNeighbourAt: (direction) ->
    assert direction instanceof Direction, "direction missing"

    neighbourCoords = Coordinates.Add @coords, direction.value
    return @grid.getCaseAtGridCoords neighbourCoords


module.exports = Case
