GridConfig = require './grid-config.coffee'
GridTheme = require './grid-theme.coffee'
GridLayout = require './grid-layout.coffee'

Block = require '../blocks/block.coffee'

Case = require './case.coffee'
CaseSprite = require './case-sprite.coffee'

Coordinates = require '../../utils/coordinates.coffee'
Rectangle = require '../../utils/geometry/rectangle.coffee'

Matrix = require '../../utils/math/matrix.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class Grid

  @V_SPEED_START = 1000
  @V_SPEED_MAX = 50

  @V_SPEED_STEP = -25

  constructor: (game, tetris, player, rectangleView, gridConfig) ->
    assert game?, "Game missing"
    assert player?, "Player missing"
    assert rectangleView instanceof Rectangle, "rectangleView missing"
    assert gridConfig?, "GridConfig missing"

    @game = game
    @tetris = tetris
    @player = player
    @config = gridConfig
    @theme = @player.theme
    @finished = false
    @speed = Grid.V_SPEED_START

    # Grid matrix initialization
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

    # Grid was initialized, we can set the layout now
    @layout = new GridLayout @game, @, rectangleView, @config
    @layout.updateCasesTransform()

    # Assign player functions
    @player.move = @move
    @player.rotate = @rotate
    @player.startAccelerate = @startAccelerate
    @player.endAccelerate = @endAccelerate
    @player.finish = @finish

    # Create and start timer
    @timer = @game.time.create false
    @initTimer()

    # Start with the next block
    @switchToNextBlock()


  initTimer: ->
    @timer.stop()
    @timer.loop @speed, @update, @
    @timer.start()


  checkCurrentBlock: ->
    return @currentBlock? and not @currentBlock.fixed


  # Generate a new random block
  generateBlock: ->
    randBlockType = Block.GetRandomBlockType()
    @currentBlock = new Block @game, @, randBlockType


  # Move the current block
  move: (direction) =>
    if not @checkCurrentBlock()
      return

    @currentBlock.move direction
    @player.sounds.move.audio.play()


  # Rotate the current block
  rotate: (direction) =>
    if not @checkCurrentBlock()
      return

    @currentBlock.rotate direction
    @player.sounds.rotate.audio.play()


  # Starts the acceleration
  startAccelerate: () =>
    if not @checkCurrentBlock()
      return

    @timer.stop()
    @timer.loop Grid.V_SPEED_MAX, @update, @
    @timer.start()


  # End the acceleration
  endAccelerate: () =>
    if not @checkCurrentBlock()
      return

    @initTimer()


  # Finish the current block
  finish: =>
    if not @checkCurrentBlock()
      return

    # TODO


  # Game over
  end: ->
    @finished = true
    @currentBlock = null
    @timer.stop()
    @player.sounds.end.audio.play()
    @tetris.triggerGridEnd(@)


  # The update function
  update: ->
    if @checkCurrentBlock()
      @currentBlock.update()


  # Sets the next block
  switchToNextBlock: ->
    @generateBlock()
    if not @currentBlock.checkBlockIntegrity()
      @currentBlock.fixed = true
      @end()


  # Returns lines which are complete (blocks)
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


  # Remove complete lines from the block which was fixed
  removeCompleteLines: (block) ->
    @player.sounds.fixed.audio.play()
    @switchToNextBlock()

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

    # Increase speed
    @speed += lineIndexes.length * Grid.V_SPEED_STEP
    @initTimer()


  # Resets / Clears the line by resetting all cases on this line
  resetLine: (lineIndex) ->
    assert lineIndex >= 0 and lineIndex < @matrix.height, "Line out of bounds"
    for i in [0...@matrix.width] by 1
      coords = new Coordinates i, lineIndex
      currCase = @getCaseAtGridCoords coords
      currCase.reset()


  # Copy a line to another
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


  # Is line empty ?
  isLineEmpty: (lineIndex) ->
    for i in [0...@matrix.width] by 1
      gridCoords = new Coordinates i, lineIndex
      currentCase = @getCaseAtGridCoords gridCoords
      if currentCase.containsBlock
        return false
    return true


  # Is the line complete ?
  isLineCompleteAt: (lineIndex) ->
    for i in [0...@matrix.width] by 1
      gridCoords = new Coordinates i, lineIndex
      currentCase = @getCaseAtGridCoords gridCoords
      if not currentCase.containsBlock
        return false
    return true


  # Return the case at game coords
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


  # Return a case in at grid coords
  getCaseAtGridCoords: (coords) ->
    assert coords instanceof Coordinates, "Coords missing"

    if coords.x >= 0 and coords.x < @matrix.width
      if coords.y >= 0 and coords.y < @matrix.height
        return @matrix.getAt coords.x, coords.y

    debug 'getCaseAtGridCoords: coords out of bounds', @, 'warning', 250, debugThemes.Grid, coords
    return null


module.exports = Grid
