Coordinates = require '../../utils/coordinates.coffee'

BlockSprites = require './block-sprites.coffee'
BlockType = require './block-type.coffee'

Direction = require '../../utils/direction.coffee'

Case = require '../grid/case.coffee'
CaseSprite = require '../grid/case-sprite.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class Block
  @GetRandomBlockType: ->
    randIndex = Math.floor(Math.random() * (BlockType.length))
    return BlockType[randIndex]


  constructor: (game, grid, type, spritesheetKey) ->
    @game = game
    @grid = grid
    @type = type
    @spritesheetKey = spritesheetKey

    @fixed = false

    # Create rotation matrixs
    nbTotalMatrixs = 1 + @type.nbRotations
    assert nbTotalMatrixs >= 1 and nbTotalMatrixs <= 4, "Nb Matrix not consistent"
    @matrixs = new Array nbTotalMatrixs
    @matrixs[0] = @type.matrix
    for i in [1...nbTotalMatrixs] by 1
      @matrixs[i] = @matrixs[i - 1].clone()
      @matrixs[i].rotateRight()

    # Create rotation matrix offsets
    @matrixsOffsets = new Array nbTotalMatrixs
    for i in [0...nbTotalMatrixs] by 1
      @matrixsOffsets[i] = new Coordinates 0, 0
      matrix = @matrixs[i]

      # Offset x
      for j in [0...matrix.width] by 1
        columnEmpty = true
        for k in [0...matrix.height] by 1
          matrixValue = matrix.getAt j, k
          if matrixValue == 1
            columnEmpty = false
            break
        if columnEmpty
          @matrixsOffsets[i].x += 1
        else
          break

      # Offset y
      for j in [0...matrix.height] by 1
        lineEmty = true
        for k in [0...matrix.width] by 1
          matrixValue = matrix.getAt k, j
          if matrixValue == 1
            lineEmty = false
            break
        if lineEmty
          @matrixsOffsets[i].y += 1
        else
          break
    
    # First matrix used
    @updateRotationMatrix 0

    # Get the spawn case
    halfGridWidth = Math.floor(@grid.config.size.w / 2)
    halfBlockWidth = Math.floor(@currentMatrix.width / 2)
    topLeftCaseX = halfGridWidth - halfBlockWidth
    topLeftCaseY = 0
    topLeftCaseCoords = new Coordinates topLeftCaseX, topLeftCaseY


    topLeftCaseCoords = Coordinates.Add topLeftCaseCoords, @currentMatrixOffset

    # Top left case according to matrixsOffsets
    @topLeftCase = @grid.getCaseAtGridCoords topLeftCaseCoords

    @spawn()


  updateRotationMatrix: (matrixIndex) ->
    assert matrixIndex >= 0 and matrixIndex < @matrixs.length, "Out of bounds"
    oldIndex = @currentMatrixIndex
    @currentMatrixIndex = matrixIndex
    @currentMatrix = @matrixs[@currentMatrixIndex]
    @currentMatrixOffset = @matrixsOffsets[@currentMatrixIndex]

    if @topLeftCase?
      oldMatrixOffset = @matrixsOffsets[oldIndex]
      if not @currentMatrixOffset.equals oldMatrixOffset
        newCoords = Coordinates.Sub @topLeftCase.coords, oldMatrixOffset
        newCoords = Coordinates.Add newCoords, @currentMatrixOffset
        @topLeftCase = @grid.getCaseAtGridCoords newCoords


  spawn: ->
    @draw()


  draw: ->
    for i in [@currentMatrixOffset.x...@currentMatrix.width] by 1
      for j in [@currentMatrixOffset.y...@currentMatrix.height] by 1
        matrixValue = @currentMatrix.getAt i, j
        if matrixValue == 1
          coords = new Coordinates i, j
          currentCase = @getCaseFromMatrix coords

          if not currentCase?
            continue

          if currentCase instanceof CaseSprite
            currentCase.sprite.frame = @type.spriteFrame


  checkBlockIntegrity: ->
    if not @topLeftCase?
      return false

    for i in [@currentMatrixOffset.x...@currentMatrix.width] by 1
      for j in [@currentMatrixOffset.y...@currentMatrix.height] by 1
        matrixValue = @currentMatrix.getAt i, j
        if matrixValue == 1
          matrixCoords = new Coordinates i, j
          currentCase = @getCaseFromMatrix matrixCoords
          if not currentCase? or currentCase.containsBlock
            return false

    return true


  getCaseFromMatrix: (matrixCoords, matrixIndex = null, topLeftCase = null) ->
    assert matrixCoords instanceof Coordinates, "No coords"

    if not matrixIndex?
      matrixIndex = @currentMatrixIndex

    if not topLeftCase?
      topLeftCase = @topLeftCase

    coords = Coordinates.Add topLeftCase.coords, matrixCoords
    coords = Coordinates.Sub coords, @matrixsOffsets[matrixIndex]
    return @grid.getCaseAtGridCoords coords


  cleanFromCase: (cleanCase, matrixIndex = null) ->
    assert cleanCase?, "Clean case : case null"

    if not matrixIndex?
      matrixIndex = @currentMatrixIndex

    matrix = @matrixs[matrixIndex]
    matrixOffset = @matrixsOffsets[matrixIndex]
    for i in [matrixOffset.x...matrix.width] by 1
      for j in [matrixOffset.y...matrix.height] by 1
        matrixValue = matrix.getAt i, j
        if matrixValue == 1
          coords = new Coordinates i, j
          currentCase = @getCaseFromMatrix coords, matrixIndex, cleanCase

          assert currentCase?, "Block clean : currentCase null"

          if currentCase instanceof CaseSprite
            currentCase.sprite.frame = BlockSprites.S_NONE


  rotate: (direction) ->
    oldMatrixIndex = @currentMatrixIndex
    newMatrixIndex = @currentMatrixIndex + direction.value.x
    if newMatrixIndex < 0
      newMatrixIndex += @matrixs.length
    else
      newMatrixIndex %= @matrixs.length

    oldCase = @topLeftCase
    @updateRotationMatrix newMatrixIndex

    if not @checkBlockIntegrity()
      @updateRotationMatrix oldMatrixIndex

      # Top Left Case may be null after the rotation
      @topLeftCase = oldCase
      return false
    else
      @cleanFromCase oldCase, oldMatrixIndex
      @draw()
      return true


  move: (direction) ->
    assert @topLeftCase?, "Top Left Case null"

    directionCoords = direction.value.clone()
    directionCoords.y = -directionCoords.y

    newCoords = Coordinates.Add @topLeftCase.coords, directionCoords
    oldCase = @grid.getCaseAtGridCoords @topLeftCase.coords
    @topLeftCase = @grid.getCaseAtGridCoords newCoords

    if not @checkBlockIntegrity()
      @topLeftCase = oldCase
      return false
    else
      @cleanFromCase oldCase, @currentMatrixIndex
      @draw()
      return true


  triggerEnd: ->
    @fixed = true

    # Inform cases of the new static block
    for i in [@currentMatrixOffset.x...@currentMatrix.width] by 1
      for j in [@currentMatrixOffset.y...@currentMatrix.height] by 1
        matrixValue = @currentMatrix.getAt i, j
        if matrixValue == 1
          coords = new Coordinates i, j
          currentCase = @getCaseFromMatrix coords

          assert currentCase?, "Trigger end: case null"

          currentCase.containsBlock = true

    @grid.removeCompleteLines(@)


  update: ->
    if @fixed
      return

    if not @move Direction.S
      @triggerEnd()


module.exports = Block
