GridTheme = require '../grid/grid-theme.coffee'

Block = require '../blocks/block.coffee'
BlockType = require '../blocks/block-type.coffee'

Direction = require '../../utils/direction.coffee'

Matrix = require '../../utils/math/matrix.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class Player
  constructor: (game, gridTheme, sounds) ->
    assert game?, "Game missing"
    assert gridTheme?, "GridTheme missing"
    assert sounds?, "Sounds missing"

    @game = game
    @theme = gridTheme

    @sounds = sounds
    for soundKey, soundValue of @sounds
      soundValue.audio = @game.add.audio soundValue.key
      soundValue.audio.volume = soundValue.volume


  rotateLeft: ->
    @rotate Direction.W


  rotateRight: ->
    @rotate Direction.E


  moveLeft: ->
    @move Direction.W


  moveRight: ->
    @move Direction.E


  ###

  Functions below will be defined by the grid associated to the player

  ###
  rotate: (direction) ->
    undefined


  move: (direction) ->
    undefined


  startAccelerate: ->
    undefined


  endAccelerate: ->
    undefined


  finish: ->
    undefined


module.exports = Player
