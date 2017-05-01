Coordinates = require '../../utils/coordinates.coffee'
Rectangle = require '../../utils/geometry/rectangle.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class GridLayout

  @GetGridRectFromGame: (gridConfig, gridView) ->
    viewMaxSize = Math.min gridView.getWidth(), gridView.getHeight()

    caseColumnMax = viewMaxSize / gridConfig.size.w
    caseLineMax = viewMaxSize / gridConfig.size.h
    caseMaxSize = Math.min caseColumnMax, caseLineMax

    gridWidth = caseMaxSize * gridConfig.w
    gridHeight = caseMaxSize * gridConfig.h

    return new Rectangle gridView.getTopLeft(), gridWidth, gridHeight


  @GetCaseSizeFromRect: (gridConfig, gridView) ->
    viewMaxSize = Math.min gridView.getWidth(), gridView.getHeight()

    caseColumnMax = viewMaxSize / gridConfig.size.w
    caseLineMax = viewMaxSize / gridConfig.size.h
    caseMaxSize = Math.min caseColumnMax, caseLineMax

    return caseMaxSize


  constructor: (game, grid, gridView, gridConfig) ->
    @game = game
    @grid = grid
    @config = gridConfig

    @caseSize = GridLayout.GetCaseSizeFromRect @config, gridView
    @width = @caseSize * @config.size.w
    @height = @caseSize * @config.size.h

    topLeftViewX = gridView.getTopLeft().x + gridView.getWidth() / 2 - @width / 2
    topLeftViewY = gridView.getTopLeft().y
    topLeftView = new Coordinates topLeftViewY, topLeftViewY

    @view = new Rectangle topLeftView, @width, @height


  updateCasesTransform: ->
    for i in [0..@config.size.h - 1] by 1
      for j in [0..@config.size.w - 1] by 1
        coords = new Coordinates i, j
        currentCase = @grid.getCaseAtGridCoords coords

        # Position
        coords = @view.getTopLeft().clone()
        coords.x += j * @caseSize
        coords.y += i * @caseSize
        currentCase.sprite.x = coords.x
        currentCase.sprite.y = coords.y

        # Scale
        scale = @caseSize / @grid.theme.spriteSize.w
        currentCase.sprite.scale.setTo scale, scale


module.exports = GridLayout
