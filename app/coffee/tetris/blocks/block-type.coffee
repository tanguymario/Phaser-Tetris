BlockSprites = require './block-sprites.coffee'
Matrix = require '../../utils/math/matrix.coffee'

MIN_ROTATIONS = 0
MAX_ROTATIONS = 4

I = [
  [0, 0, 0, 0],
  [0, 0, 0, 0],
  [1, 1, 1, 1],
  [0, 0, 0, 0]
]

O = [
  [1, 1],
  [1, 1]
]

T = [
  [0, 0, 0],
  [1, 1, 1],
  [0, 1, 0]
]

L = [
  [0, 0, 0],
  [1, 1, 1],
  [1, 0, 0]
]

J = [
  [0, 0, 0],
  [1, 1, 1],
  [0, 0, 1]
]

Z = [
  [0, 0, 0],
  [1, 1, 0],
  [0, 1, 1]
]

S = [
  [0, 0, 0],
  [0, 1, 1],
  [1, 1, 0],
]

Q = [
  [0, 0, 0],
  [1, 1, 1],
  [1, 0, 1]
]

module.exports = [
  {
    name: "I"
    matrix: new Matrix I
    spriteFrame: BlockSprites.S_CYAN
    nbRotations: 1
  },
  {
    name: "O"
    matrix: new Matrix O
    spriteFrame: BlockSprites.S_YELLOW
    nbRotations: 0
  },
  {
    name: "T"
    matrix: new Matrix T
    spriteFrame: BlockSprites.S_PURPLE
    nbRotations: 3
  },
  {
    name: "L"
    matrix: new Matrix L
    spriteFrame: BlockSprites.S_ORANGE
    nbRotations: 3
  },
  {
    name: "J"
    matrix: new Matrix J
    spriteFrame: BlockSprites.S_BLUE
    nbRotations: 3
  },
  {
    name: "Z"
    matrix: new Matrix Z
    spriteFrame: BlockSprites.S_RED
    nbRotations: 1
  },
  {
    name: "S"
    matrix: new Matrix S
    spriteFrame: BlockSprites.S_GREEN
    nbRotations: 1
  },
  {
    name: "Q"
    matrix: new Matrix Q
    spriteFrame: BlockSprites.S_GREEN
    nbRotations: 3
  }
]
