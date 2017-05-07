GridTheme = require '../grid/grid-theme.coffee'

Block = require '../blocks/block.coffee'
BlockType = require '../blocks/block-type.coffee'

Direction = require '../../utils/direction.coffee'

Matrix = require '../../utils/math/matrix.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class Player
  constructor: (game, gridTheme) ->
    assert game?, "Game missing"

    @game = game
    @theme = gridTheme
    @currentBlock = null


  generateBlock: ->
    randBlockType = Block.GetRandomBlockType()
    @currentBlock = new Block @game, @grid, randBlockType


  rotateLeft: ->
    @rotate Direction.W


  rotateRight: ->
    @rotate Direction.E


  rotate: (direction) ->
    @currentBlock.rotate direction


  moveLeft: ->
    @move Direction.W


  moveRight: ->
    @move Direction.E


  move: (direction) ->
    if not @currentBlock?
      return

    @currentBlock.move direction

module.exports = Player
