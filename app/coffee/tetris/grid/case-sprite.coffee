Case = require './case.coffee'

BlockSprites = require '../blocks/block-sprites.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'
class CaseSprite extends Case
  constructor: (game, grid, gridCoords, theme) ->
    super game, grid, gridCoords, theme

    @sprite = @game.add.sprite 0, 0, @theme.key, BlockSprites.S_NONE


module.exports = CaseSprite
