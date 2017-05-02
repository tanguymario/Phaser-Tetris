assert = require '../assert.coffee'

Direction = require '../direction.coffee'

class Matrix
  @DEFAULT_SIZE = 4
  @NB_BORDERS = 4

  @GetDoubleArrayCopy: (array) ->
    assert Array.isArray matrix
    assert Array.isArray matrix[0]

    height = array.length
    newArr = new Array height
    for i in [0..height - 1] by 1
      width = array[i].length
      newArr[i] = new Array width
      for j in [0..width - 1] by 1
        newArr[i][j] = array[i][j]

    return newArr


  @Identity: (size = Matrix.DEFAULT_SIZE) ->
    identity = new Array size
    for i in [0..size - 1] by 1
      identity[i] = new Array size
      for j in [0..size - 1] by 1
        identity[i][j] = if i == j then 1 else 0

    return new Matrix identity


  @Add: (matA, matB) ->
    assert matA.width == matB.width, "Not same width"
    assert matA.height == matB.height, "Not same height"

    result = new Array matA.height
    for i in [0..matA.height.length - 1] by 1
      result[i] = new Array matA.width
      for j in [0..matA.width - 1] by 1
        result[i][j] = matA[i][j] + matB[i][j]

    return new Matrix result


  @Mult: (matA, matB) ->
    assert matA.width == matB.width, "Not same width"
    assert matA.height == matB.height, "Not same height"

    # TODO
    throw "Not Implemented"

  constructor: (matrix, copy = false) ->
    assert Array.isArray matrix
    assert matrix.length >= 0, "Array size cannot be negative"
    assert matrix[0].length >= 0, "Double array size cannot be negative"

    @height = matrix.length
    @width = matrix[0].length

    for i in [0..@height - 1] by 1
      assert matrix[i].length == @width, "Matrix width differences found!"

    if copy
      @matrix = Matrix.GetDoubleArrayCopy matrix
    else
      @matrix = matrix


  getAt: (i, j) ->
    assert i >= 0 and i < @height, "Line out of bounds"
    assert j >= 0 and j < @width, "Column out of bounds"
    return @matrix[i][j]


  getTransposition: ->
    newMatrix = @clone()
    newMatrix.setTransposition()
    return newMatrix


  setTransposition: ->
    if @width == @height
      for i in [1..@height - 1] by 1
        for j in [0..i - 1] by 1
          temp = @matrix[i][j]
          @matrix[i][j] = @matrix[j][i]
          @matrix[j][i] = temp
    else
      newMatrix = new Array @width
      for i in [0..@width - 1] by 1
        newMatrix[i] = new Array @height
        for j in [0..@height - 1] by 1
          newMatrix[i][j] = @matrix[j][i]

      @matrix = newMatrix
      @height = newMatrix.length
      @width = newMatrix[0].length


  getRotation: (direction) ->
    newMatrix = @clone()
    newMatrix.rotate angle
    return newMatrix


  setRotation: (direction) ->
    if direction == Direction.N
      return

    if @width != @height
      throw "Not Implemented"

    switch direction
      when Direction.E then @rotateRight()
      when Direction.W then @rotateLeft()
      when Direction.S then @rotateBack()
      else throw "Angle must be 90, 180 or 270"


  rotateRight: ->
    halfHeight = Math.trunc (@height - 1) / 2
    for depth in [0..halfHeight - 1] by 1
      nbCasesToDo = @height - 1 - depth
      for i in [0..nbCasesToDo - 1] by 1
        nbCasesLeft = nbCasesToDo - i

        firstCell = @matrix[depth][i]
        secondCell = @matrix[i][nbCasesToDo]
        thirdCell = @matrix[nbCasesToDo][nbCasesLeft]
        fourthCell = @matrix[nbCasesLeft][depth]

        @matrix[i][nbCasesToDo] = firstCell
        @matrix[nbCasesToDo][nbCasesLeft] = secondCell
        @matrix[nbCasesLeft][depth] = thirdCell
        @matrix[depth][i] = fourthCell


  rotateLeft: ->



  rotateBack: ->



  clone: ->
    cloneMatrix = Matrix.GetDoubleArrayCopy @matrix
    return new Matrix cloneMatrix


  toString: ->
    return """
    Matrix :
      - width: #{@width}
      - height: #{@height}
      - matrix:
    #{
    matrixString = ""
    for i in [0..@height - 1] by 1
      for j in [0..@width - 1] by 1
        matrixString += @matrix[i][j].toString() + " "
      matrixString += "\n"
    matrixString
    }
    """


module.exports = Matrix
