Polygon = require './polygon.coffee'

Coordinates = require '../coordinates.coffee'

assert = require '../assert.coffee'

class Square extends Polygon
  constructor: (topLeft, size) ->
    assert topLeft instanceof Coordinates, "Top Left is not of type Coordinates"
    assert bottomRight instanceof Coordinates, "Bottom Right is not of type Coordinates"
    assert size >= 0, "size cannot be negative"

    @size = size

    topRight = new Coordinates topLeft.x + @size, topLeft.y
    bottomLeft = new Coordinates topLeft.x, topLeft.y + @size
    bottomRight = new Coordinates topRight.x, bottomLeft.y

    super topLeft, bottomLeft, bottomRight, topRight


  getSize: ->
    return @size


  getDiagonalLength: ->
    return @size * Math.sqrt 2


  getTopLeft: ->
    return @points[0]


  getBottomLeft: ->
    return @points[1]


  getTopRight: ->
    return @points[3]


  getBottomRight: ->
    return @points[2]


  clone: ->
    return new Square @getTopLeft(), @size


  toString: ->
    return """
    Square :
      - Top Right :
        #{@getTopLeft().toString()}
      - Bottom Left :
        #{@getBottomLeft().toString()}
      - Top Left :
        #{@getTopLeft().toString()}
      - Bottom Right :
        #{@getBottomRight().toString()}
      - Size :
        #{@size}
    """


module.exports = Square
