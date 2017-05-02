BlockType = require './block-type.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class Block

  @GetRandomBlockType: ->
    randIndex = Math.floor(Math.random() * (BlockType.length - 1))
    return BlockType[randIndex]

  constructor: (game, grid, type) ->

    @game = game
    @grid = grid
    @type = type


  update: ->




module.exports = Block
