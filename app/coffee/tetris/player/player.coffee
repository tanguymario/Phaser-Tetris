GridTheme = require '../grid/grid-theme.coffee'

Block = require '../blocks/block.coffee'
BlockType = require '../blocks/block-type.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class Player
  constructor: (game, gridTheme) ->
    assert game?, "Game missing"

    @game = game
    @theme = gridTheme


  generateBlock: ->
    randBlockType = Block.GetRandomBlockType()

    console.log randBlockType.matrix.toString()
    randBlockType.matrix.rotateRight()
    console.log randBlockType.matrix.toString()

    @currentBlock = 1


  moveLeft: ->
    move -1


  moveRight: ->
    move 1


  move: (value) ->
    assert @grid?, "Grid missing"
    debug 'move: ' + value


module.exports = Player
