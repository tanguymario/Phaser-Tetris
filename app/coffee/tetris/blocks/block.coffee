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
    randIndex = Math.floor(Math.random() * (BlockType.length - 1))
    return BlockType[randIndex]


  constructor: (game, grid, type, spritesheetKey) ->
    @game = game
    @grid = grid
    @type = type
    @spritesheetKey = spritesheetKey

    # Matrix creation
    nbTotalMatrix = 1 + @type.nbRotations

    assert nbTotalMatrix >= 1 and nbTotalMatrix <= 4, "Nb Matrix not consistent"

    @matrixs = new Array nbTotalMatrix
    @matrixs[0] = @type.matrix

    for i in [1...nbTotalMatrix] by 1
      @matrixs[i] = @matrixs[i - 1].clone()
      @matrixs[i].rotateRight()

    @currentMatrixIndex = 0

    # @blockSprites = @game.add.group()

    halfGridWidth = Math.floor(@grid.config.size.w / 2)
    halfBlockWidth = Math.floor(@getCurrentMatrix().width / 2)
    topLeftCaseX = halfGridWidth - halfBlockWidth
    topLeftCaseY = 0
    topLeftCaseCoords = new Coordinates topLeftCaseX, topLeftCaseY

    @topLeftCase = @grid.getCaseAtGridCoords topLeftCaseCoords

    console.log topLeftCaseCoords
    console.log @topLeftCase.coords

    @spawn()


  getCurrentMatrix: ->
    assert @matrixs[@currentMatrixIndex]?, "Current Matrix is null in @matrixs"
    return @matrixs[@currentMatrixIndex]


  spawn: ->
    @draw()


  draw: ->
    currentMatrix = @getCurrentMatrix()
    for i in [0...currentMatrix.width] by 1
      for j in [0...currentMatrix.height] by 1
        matrixValue = currentMatrix.getAt i, j
        if matrixValue == 1
          caseCoords = Coordinates.Add @topLeftCase.coords, new Coordinates(i, j)
          currentCase = @grid.getCaseAtGridCoords caseCoords

          assert currentCase?, "Block draw : currentCase null"

          if currentCase instanceof CaseSprite
            currentCase.sprite.frame = @type.spriteFrame


  checkBlockIntegrity: ->
    if not @topLeftCase?
      return false

    currentMatrix = @getCurrentMatrix()
    for i in [0...currentMatrix.width] by 1
      for j in [0...currentMatrix.height] by 1
        matrixValue = currentMatrix.getAt i, j
        if matrixValue == 1
          coords = new Coordinates i, j
          coords = Coordinates.Add @topLeftCase.coords, coords
          currentCase = @grid.getCaseAtGridCoords coords
          if not currentCase? or currentCase.containsBlock
            return false

    return true


  rotateLeft: (force = false) ->
    @currentMatrixIndex -= 1
    if @currentMatrixIndex < 0
      @currentMatrixIndex += @matrixs.length

    if not force and not @checkBlockIntegrity()
      @rotateRight true


  cleanFromCase: (currCase) ->
    assert currCase?, "Clean case : case null"

    currentMatrix = @getCurrentMatrix()
    for i in [0...currentMatrix.width] by 1
      for j in [0...currentMatrix.height] by 1
        matrixValue = currentMatrix.getAt i, j
        if matrixValue == 1
          caseCoords = Coordinates.Add currCase.coords, new Coordinates(i, j)
          currentCase = @grid.getCaseAtGridCoords caseCoords

          assert currentCase?, "Block clean : currentCase null"

          if currentCase instanceof CaseSprite
            currentCase.sprite.frame = BlockSprites.S_NONE


  move: (direction) ->
    assert @topLeftCase?, "Top Left Case null"

    directionCoords = direction.value.clone()
    directionCoords.y = -directionCoords.y

    newCoords = Coordinates.Add @topLeftCase.coords, directionCoords
    oldCase = @grid.getCaseAtGridCoords @topLeftCase.coords
    @topLeftCase = @grid.getCaseAtGridCoords newCoords

    if not @checkBlockIntegrity()
      @topLeftCase = oldCase
    else
      @cleanFromCase oldCase
      @draw()


  rotateRight: (force = false) ->
    @currentMatrixIndex += 1
    @currentMatrixIndex %= @matrixs.length
    if not force and not @checkBlockIntegrity()
      @rotateLeft true


  update: ->
    @move Direction.S



module.exports = Block
