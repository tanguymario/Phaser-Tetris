GridTheme = require '../grid/grid-theme.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class Player
  constructor: (game, gridTheme) ->
    assert game?, "Game missing"
    
    @game = game
    @theme = gridTheme


    moveLeft: ->
      move -1


    moveRight: ->
      move 1


    move: (value) ->
      assert @grid?, "Grid missing"
      debug 'move: ' + value


module.exports = Player
