GridConfig = require './grid-config.coffee'
GridTheme = require './grid-theme.coffee'
GridLayout = require './grid-layout.coffee'

Case = require './case.coffee'
CaseSprite = require './case-sprite.coffee'

Coordinates = require '../../utils/coordinates.coffee'
Rectangle = require '../../utils/geometry/rectangle.coffee'

Matrix = require '../../utils/math/matrix.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class Grid
  constructor: (game, rectangleView, gridConfig, gridTheme) ->
    assert game?, "Game missing"
    assert rectangleView instanceof Rectangle, "rectangleView missing"

    @game = game
    @config = gridConfig
    @theme = gridTheme

    @layout = new GridLayout @game, @, rectangleView, @config

    # Grid initialisation
    nbLines = @config.size.h + @config.nbHiddenLines
    tab = new Array nbLines
    for i in [0...nbLines] by 1
      tab[i] = new Array @config.size.w
      for j in [0...@config.size.w] by 1
        coords = new Coordinates j, i

        if i >= @config.nbHiddenLines
          tab[i][j] = new CaseSprite @game, @, coords, @theme
        else
          tab[i][j] = new Case @game, @, coords, @theme

    @matrix = new Matrix tab

    @layout.updateCasesTransform()


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
    assert coords instanceof Coordinates, "Coords missing"

    if coords.x >= 0 and coords.x < @matrix.width
      if coords.y >= 0 and coords.y < @matrix.height
        return @matrix.getAt coords.x, coords.y

    debug 'getCaseAtGridCoords: coords out of bounds', @, 'warning', 250, debugThemes.Grid, coords
    return null

module.exports = Grid
