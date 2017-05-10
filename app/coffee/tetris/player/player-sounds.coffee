mainDir = 'assets/snd/effects/'
classicDir = mainDir + 'classic/'

module.exports =
  classic:
    move:
      key: 'classic-move'
      src: classicDir + 'move.wav'
      volume: 0.25
    rotate:
      key: 'classic-rotate'
      src: classicDir + 'rotate.mp3'
      volume: 0.45
    fixed:
      key: 'classic-fixed'
      src: classicDir + 'fixed.mp3'
      volume: 1
    end:
      key: 'classic-end'
      src: classicDir + 'end.mp3'
      volume: 1
