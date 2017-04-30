GridConfig = require './grid-config.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class Grid
  constructor: (gridConfig) ->
    assert gridConfig instanceof GridConfig, "GridConfig missing"

    @gridConfig = gridConfig


module.exports = Grid
