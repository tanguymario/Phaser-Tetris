Coordinates = require '../../utils/coordinates.coffee'
Rectangle = require '../../utils/geometry/rectangle.coffee'

CaseSprite = require './case-sprite.coffee'

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
    caseMaxSize = Math.min(caseColumnMax, caseLineMax) * 2

    return caseMaxSize


  constructor: (game, grid, gridView, gridConfig) ->
    @game = game
    @grid = grid
    @config = gridConfig

    # Max case size
    @caseSize = GridLayout.GetCaseSizeFromRect @config, gridView
    @caseSize *= @config.casesScale

    @width = @caseSize * @config.size.w
    @height = @caseSize * @config.size.h

    topLeftViewX = gridView.getTopLeft().x + gridView.getWidth() / 2 - @width / 2
    topLeftViewY = gridView.getTopLeft().y + gridView.getHeight() / 2 - @height / 2
    topLeftView = new Coordinates topLeftViewX, topLeftViewY

    @view = new Rectangle topLeftView, @width, @height


  updateCasesTransform: ->
    totalHeight = @config.size.h + @config.nbHiddenLines
    scale = @caseSize / @grid.theme.spriteSize.w
    for i in [0...@config.size.w] by 1
      for j in [@config.nbHiddenLines...totalHeight] by 1
        coords = new Coordinates i, j
        currentCase = @grid.getCaseAtGridCoords coords

        # Position
        coords = @view.getTopLeft().clone()
        coords.x += i * @caseSize
        coords.y += (j - @config.nbHiddenLines) * @caseSize
        currentCase.sprite.x = coords.x
        currentCase.sprite.y = coords.y

        # Scale
        currentCase.sprite.scale.setTo scale, scale


module.exports = GridLayout
