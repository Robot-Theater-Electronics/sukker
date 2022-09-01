/// sound test:

Ndef(\x, {WhiteNoise.ar(0.1)}).play(0,0); // middle  - MAIN L
Ndef(\x, {WhiteNoise.ar(0.1)}).play(1,1); // frontR (colonial store) - MAIN R
Ndef(\x, {WhiteNoise.ar(0.1)}).play(2,1); // fronL (office) - PHONES L
Ndef(\x, {WhiteNoise.ar(0.1)}).play(3,1); // middleL2 (70's) - PHONES R
Ndef(\x, {WhiteNoise.ar(0.04)}).play(4,1); // back1 (1940's)
Ndef(\x, {WhiteNoise.ar(0.04)}).play(5,1); // back2

// speakers
1 -> middle
2 -> frontR (colonial store)
3 -> fronL (office)
4 -> middleL2 (70's)
5 -> back1 (1940's)
6 -> back2


// mics
  1 -> Jae
  2 -> Per egil
  3 -> Neserin

  // intro walk

  -> 70's -> sun ra
  -> office -> ligeti
  -> colonial store -> grieg (?)
  -> 1940's -> anne brown piano



  // 70's
  Ndef(\a, {PlayBuf.ar(2, ~buffers['sunra']['synth2'], 1, loop: 1).sum*0.3}).play(0,1);
  Ndef(\b, {PlayBuf.ar(2, ~buffers['sunra']['vocals2'], 1, loop: 1).sum*0.3}).play(0,1);
  // colonial store
  Ndef(\c, {PlayBuf.ar(2, ~buffers['grieg'], 1, loop: 1).sum*0.04}).play(1,1);
  // 1940
  Ndef(\d, {PlayBuf.ar(2, ~buffers['annebrown']['piano'], 1, loop: 1).sum*0.1}).play(4,1);
    Ndef(\f, {PlayBuf.ar(2, ~buffers['annebrown']['vocals'], 1, loop: 1).sum*0.1}).play(4,1);
  // office
  Ndef(\e, {PlayBuf.ar(2, ~buffers['office']['original'], 1, loop: 1).sum*0.4}).play(2,1);


  Ndef.all.do{|n| n.stop(5); }

  s.prepareForRecord(numChannels:5);
  s.record
  s.stopRecording
 