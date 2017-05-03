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
    for i in [0...height] by 1
      width = array[i].length
      newArr[i] = new Array width
      for j in [0...width] by 1
        newArr[i][j] = array[i][j]

    return newArr


  @Identity: (size = Matrix.DEFAULT_SIZE) ->
    identity = new Array size
    for i in [0...size] by 1
      identity[i] = new Array size
      for j in [0...size] by 1
        identity[i][j] = if i == j then 1 else 0

    return new Matrix identity


  @Add: (matA, matB) ->
    assert matA.width == matB.width, "Not same width"
    assert matA.height == matB.height, "Not same height"

    result = new Array matA.height
    for i in [0...matA.height.length] by 1
      result[i] = new Array matA.width
      for j in [0...matA.width] by 1
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

    for i in [0...@height] by 1
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
      for i in [1...@height] by 1
        for j in [0...i] by 1
          temp = @matrix[i][j]
          @matrix[i][j] = @matrix[j][i]
          @matrix[j][i] = temp
    else
      newMatrix = new Array @width
      for i in [0...@width] by 1
        newMatrix[i] = new Array @height
        for j in [0...@height] by 1
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
    halfHeight = Math.trunc @height / 2
    for depth in [0...halfHeight] by 1
      nbCasesToDo = @height - 1 - depth * 2
      nbCasesToDoDepth = nbCasesToDo + depth
      for i in [0...nbCasesToDo] by 1
        nbCasesLeft = nbCasesToDo - i
        nbCasesLeftDepth = nbCasesLeft + depth

        incrementalDepth = i + depth

        # Get cell values
        firstCell = @matrix[depth][incrementalDepth]
        secondCell = @matrix[incrementalDepth][nbCasesToDoDepth]
        thirdCell = @matrix[nbCasesToDoDepth][nbCasesLeftDepth]
        fourthCell = @matrix[nbCasesLeftDepth][depth]

        # Swap values
        @matrix[incrementalDepth][nbCasesToDoDepth] = firstCell
        @matrix[nbCasesToDoDepth][nbCasesLeftDepth] = secondCell
        @matrix[nbCasesLeftDepth][depth] = thirdCell
        @matrix[depth][incrementalDepth] = fourthCell


  rotateLeft: ->
    halfHeight = Math.trunc @height / 2
    for depth in [0...halfHeight] by 1
      nbCasesToDo = @height - 1 - depth * 2
      nbCasesToDoDepth = nbCasesToDo + depth
      for i in [0...nbCasesToDo] by 1
        nbCasesLeft = nbCasesToDo - i
        nbCasesLeftDepth = nbCasesLeft + depth

        incrementalDepth = i + depth

        # Get cell values
        firstCell = @matrix[depth][incrementalDepth]
        secondCell = @matrix[nbCasesLeftDepth][depth]
        thirdCell = @matrix[nbCasesToDoDepth][nbCasesLeftDepth]
        fourthCell = @matrix[incrementalDepth][nbCasesToDoDepth]

        # Swap values
        @matrix[nbCasesLeftDepth][depth] = firstCell
        @matrix[nbCasesToDoDepth][nbCasesLeftDepth] = secondCell
        @matrix[incrementalDepth][nbCasesToDoDepth] = thirdCell
        @matrix[depth][incrementalDepth] = fourthCell


  # TODO
  rotateBack: ->
    halfheight = Math.trunc @height / 2
    for i in [0...@height] by 1
      nbCasesToDo = @width - i
      bottomLine = nbCasesToDo - 1
      for j in [0...nbCasesToDo] by 1
        rightColumn = @width - 1 - j

        # Swap
        temp = @matrix[i][j]
        @matrix[i][j] = @matrix[bottomLine][rightColumn]
        @matrix[bottomLine][rightColumn] = temp


  flipHorizontally: ->
    halfWidth = Math.trunc @width / 2
    for i in [0...@height] by 1
      for j in [0...halfWidth] by 1
        rightColumn = @width - 1 - j

        # Swap values
        temp = @matrix[i][j]
        @matrix[i][j] = @matrix[i][rightColumn]
        @matrix[i][rightColumn] = temp


  flipVertically: ->
    halfHeight = Math.trunc @height / 2
    for i in [0...halfHeight] by 1
      bottomLine = @height - 1 - i
      for j in [0...@height] by 1
        # Swap values
        temp = @matrix[i][j]
        @matrix[i][j] = @matrix[bottomLine][j]
        @matrix[bottomLine][j] = temp


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
    for i in [0...@height] by 1
      for j in [0...@width] by 1
        matrixString += @matrix[i][j].toString() + " "
      matrixString += "\n"
    matrixString
    }
    """


module.exports = Matrix
