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


  checkCompleteLines: (block) ->
    completeLineIndexes = new Array()

    # Browse lines of new block
    for j in [block.currentMatrixOffset.y...block.currentMatrix.height] by 1
      currentLine = j + block.topLeftCase.coords.y - block.currentMatrixOffset.y
      if currentLine >= @matrix.height
        break

      if @isLineCompleteAt currentLine
        completeLineIndexes.push currentLine

    return completeLineIndexes.reverse()


  removeCompleteLines: (block) ->
    lineIndexes = @checkCompleteLines block
    if lineIndexes.length <= 0
      return

    nbCompleteLines = 1
    removingLine = true
    currentLineIndex = lineIndexes[0]
    @resetLine currentLineIndex

    while removingLine
      currentLineIndex -= 1

      if lineIndexes.length > nbCompleteLines
        if currentLineIndex == lineIndexes[nbCompleteLines]
          nbCompleteLines += 1
          @resetLine currentLineIndex
          continue

      @copyLineTo currentLineIndex, currentLineIndex + nbCompleteLines
      @resetLine currentLineIndex

      removingLine = not @isLineEmpty currentLineIndex - 1

    @resetLine currentLineIndex


  resetLine: (lineIndex) ->
    assert lineIndex >= 0 and lineIndex < @matrix.height, "Line out of bounds"
    for i in [0...@matrix.width] by 1
      coords = new Coordinates i, lineIndex
      currCase = @getCaseAtGridCoords coords
      currCase.reset()


  copyLineTo: (sourceLine, targetLine) ->
    for i in [0...@matrix.width] by 1
      sourceCoords = new Coordinates i, sourceLine
      targetCoords = new Coordinates i, targetLine

      sourceCase = @getCaseAtGridCoords sourceCoords
      assert sourceCase?, "Copy line to : source case null"

      targetCase = @getCaseAtGridCoords targetCoords
      assert targetCase?, "Copy line to : case null"

      # Swap a few values between cases
      targetCase.containsBlock = sourceCase.containsBlock
      if sourceCase instanceof CaseSprite and targetCase instanceof CaseSprite
        targetCase.sprite.frame = sourceCase.sprite.frame


  isLineEmpty: (lineIndex) ->
    for i in [0...@matrix.width] by 1
      gridCoords = new Coordinates i, lineIndex
      currentCase = @getCaseAtGridCoords gridCoords
      if currentCase.containsBlock
        return false
    return true


  isLineCompleteAt: (lineIndex) ->
    for i in [0...@matrix.width] by 1
      gridCoords = new Coordinates i, lineIndex
      currentCase = @getCaseAtGridCoords gridCoords
      if not currentCase.containsBlock
        return false
    return true


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
