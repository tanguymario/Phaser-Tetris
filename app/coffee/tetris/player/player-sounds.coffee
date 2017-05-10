mainDir = 'assets/snd/effects/'
classicDir = mainDir + 'classic/'

module.exports =
  classic:
    move:
      key: 'classic-move'
      src: classicDir + 'move.wav'
    rotate:
      key: 'classic-rotate'
      src: classicDir + 'rotate.wav'
    fixed:
      key: 'classic-fixed'
      src: classicDir + 'fixed.wav'
    end:
      key: 'classic-end'
      src: classicDir + 'end.mp3'
