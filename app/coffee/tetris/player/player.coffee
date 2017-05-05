GridTheme = require '../grid/grid-theme.coffee'

Block = require '../blocks/block.coffee'
BlockType = require '../blocks/block-type.coffee'

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
    


  moveLeft: ->
    move -1


  moveRight: ->
    move 1


  move: (value) ->
    if not @currentBlock?
      return

    debug 'move: ' + value


module.exports = Player
