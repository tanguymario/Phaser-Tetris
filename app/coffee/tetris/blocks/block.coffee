Coordinates = require '../../utils/coordinates.coffee'

BlockType = require './block-type.coffee'

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

    @spawn()


  getCurrentMatrix: ->
    assert @matrixs[@currentMatrixIndex]?, "Current Matrix is null in @matrixs"
    assert @matrixs[@currentMatrixIndex].matrix?, "Current matrix object is null"

    return @matrixs[@currentMatrixIndex].matrix


  spawn: ->
    assert @topLeftCase instanceof Case, "Block Spawn: Not a case"
    @draw()


  draw: ->
    currentMatrix = @getCurrentMatrix()
    for i in [0...currentMatrix.height] by 1
      for j in [0...currentMatrix.width] by 1
        if currentMatrix[i][j] == 1
          caseCoords = Coordinates.Add @topLeftCase.coords, new Coordinates(j, i)
          currentCase = @grid.getCaseAtGridCoords caseCoords

          assert currentCase?, "Block draw : currentCase null"

          if currentCase instanceof CaseSprite
            currentCase.sprite.frame = @type.spriteFrame


  checkBlockIntegrity: (matrix, topLeftCase) ->
    return true


  rotateLeft: (force = false) ->
    @currentMatrixIndex -= 1
    if @currentMatrixIndex < 0
      @currentMatrixIndex += @matrixs.length

    if not force and not @checkBlockIntegrity()
      @rotateRight true


  rotateRight: (force = false) ->
    @currentMatrixIndex += 1
    @currentMatrixIndex %= @matrixs.length
    if not force and not @checkBlockIntegrity()
      @rotateLeft true


  update: ->




module.exports = Block
