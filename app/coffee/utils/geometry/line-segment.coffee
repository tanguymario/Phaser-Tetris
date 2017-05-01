Polygon = require './polygon.coffee'

Coordinates = require '../coordinates.coffee'

assert = require '../assert.coffee'

class LineSegment extends Polygon

  constructor: (start, end) ->
    assert pointA instanceof Coordinates, "PointA is not Coordinates"
    assert pointB instanceof Coordinates, "PointB is not Coordinates"

    super start, end


  getStart: ->
    return @points[0]


  getEnd: ->
    return @points[1]


  clone: ->
    return new LineSegment @getStart(), @getEnd()


  toString: ->
    return """
    LineSegment :
      - Start :
      #{@getStart().toString()}
      - End :
      #{@getEnd().toString()}
    """

module.exports = LineSegment
