GridTheme = require '../grid/grid-theme.coffee'

Block = require '../blocks/block.coffee'
BlockType = require '../blocks/block-type.coffee'

Direction = require '../../utils/direction.coffee'

Matrix = require '../../utils/math/matrix.coffee'

assert = require '../../utils/assert.coffee'

debug       = require '../../utils/debug.coffee'
debugThemes = require '../../utils/debug-themes.coffee'

class Player
  @V_DEF_INTERVAL = 1000
  @V_DEF_ACCELERATION = 50

  constructor: (game, gridTheme, sounds) ->
    assert game?, "Game missing"
    assert gridTheme?, "GridTheme missing"
    assert sounds?, "Sounds missing"

    @game = game
    @theme = gridTheme
    @sounds = sounds
    @currentBlock = null

    @timer = @game.time.events.loop Player.V_DEF_INTERVAL, @update, @


  generateBlock: ->
    randBlockType = Block.GetRandomBlockType()
    @currentBlock = new Block @game, @grid, randBlockType


  rotateLeft: ->
    @rotate Direction.W


  rotateRight: ->
    @rotate Direction.E


  rotate: (direction) ->
    @currentBlock.rotate direction
    @game.sound.play @sounds.rotate.key


  moveLeft: ->
    @move Direction.W


  moveRight: ->
    @move Direction.E


  move: (direction) ->
    if not @currentBlock?
      return

    @currentBlock.move direction
    @game.sound.play @sounds.move.key


  startAccelerate: ->
    @timer.delay = Player.V_DEF_ACCELERATION


  endAccelerate: ->
    @timer.delay = Player.V_DEF_INTERVAL


  finish: ->
    # TODO


  end: ->
    @timer.timer.destroy()
    @game.sound.play @sounds.end.key
    console.log "THE END"


  update: ->
    if not @currentBlock? or @currentBlock.fixed
      @generateBlock()
      if not @currentBlock.checkBlockIntegrity()
        @end()
    else
      @currentBlock.update()


module.exports = Player
