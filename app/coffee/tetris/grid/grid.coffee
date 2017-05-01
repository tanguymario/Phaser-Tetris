GridConfig = require './grid-config.coffee'
GridTheme = require './grid-theme.coffee'
GridLayout = require './grid-layout.coffee'
Case = require './case.coffee'

Rectangle = require '../../utils/geometry/rectangle.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class Grid
  constructor: (game, rectangleView, gridConfig, gridTheme) ->
    assert game?, "Game missing"
    assert rectangleView instanceof Rectangle, "rectangleView missing"
    assert gridConfig in GridConfig, "GridConfig missing"
    assert gridTheme in gridTheme, "GridTheme missing"

    @game = game
    @config = gridConfig
    @theme = gridTheme
    @layout = new GridLayout @game, @, rectangleView, @config

    # Grid initialisation
    @tab = new Array @config.size.w
    for i in [0..@config.size.w - 1] by 1
      @tab[i] = new Array @config.size.h
      for j in [0..@config.size.h - 1] by 1
        coords = new Coordinates i, j
        @tab[i][j] = new Case @game, @, coords, @theme


  getCaseAtGameCoords: (coords) ->
    debug 'getCaseAtGameCoords...', @, 'info', 100, debugThemes.Grid
    if @layout.view.isInside coords, false
      topLeft = @layout.view.getTopLeft()
      coords = Coordinates.Sub coords, topLeft
      column = Math.floor coords.x / @layout.caseSize
      line = Math.floor coords.y / @layout.caseSize

      gridCoords = new Coordinates column, line
      return @getCaseAtGridCoords gridCoords

    return null


  getCaseAtGridCoords: (coords) ->
    assert coords instanceof Coordinates, "coords missing"

    if gridcoords.x >= 0 and gridcoords.x < @w
      if gridcoords.y >= 0 and gridcoords.y < @h
        return @tab[gridcoords.x][gridcoords.y]

    debug 'getCaseAtGridCoords: coords out of bounds', @, 'warning', 250, debugThemes.Grid, coords
    return null

module.exports = Grid
