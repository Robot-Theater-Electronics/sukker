// building maintenance

~bfreqS = 1898;
~bfreqE = 1902;

Ndef(\delay1, {2*CombN.ar(Resonz.ar(In.ar(~busfx1).distort, (1/2)*LFSaw.kr(1).range(~bfreqS, ~bfreqE), 0.2), 0.2, 0.4, 8) }).play(7,1, addAction: \addToTail);
Ndef(\delay1).fadeTime_(2);

 // 1970's freq
Ndef(\blackFreq, {1*SinOsc.ar([~bfreqS * Line.kr(1/24, 1/8, 20), LFPulse.kr(1).range(~bfreqS, ~bfreqE) * 1/8]).distort* 0.3 * LFNoise1.kr(1/4).range(0, 1)}).play(~busfx1,2, addAction: \addToHead);
Ndef(\blackFreqB, {1.4*SinOsc.ar([~bfreqS * Line.kr(1/24, 1/16, 20), ~bfreqS/2 * Line.kr(1/24, 1/4, 20)]) * 0.4 * LFNoise1.kr(1/4).range(0, 1)}).play(~busfx1,2,addAction: \addToHead);

Ndef(\blackFreq).fadeTime_(4);
Ndef(\blackFreqB).fadeTime_(4);

Ndef(\blackFreq).stop(8);
Ndef(\blackFreqB ).stop(8);

t.tempo=1

// mainentance soundscape start

Pdef(\1, Pbind(\instrument, \sampleNarcodeStrPZ, \buf, ~buffers['building']['water1'], \amp, Pwhite(0.3, 1), \out, 0, \st, Pwhite(11, 13), \rl, Pwhite(1, 2), \pos, Pwhite(0, 0.7), \dur, Pwhite(17, 20), \lag, 0) ).play;
Pdef(\2, Pbind(\instrument, \sampleNarcodeStrPZ, \buf, ~buffers['building']['water3'], \amp, Pwhite(0.5, 1), \out, 2, \st, Pwhite(13, 18), \rl, Pwhite(1, 2), \pos, Pwhite(0, 0.7), \dur, Pwhite(13, 20), \lag, 0) ).play;
Pdef(\3, Pbind(\instrument, \sampleNarcodeStrPZ, \buf, ~buffers['building']['water3'], \amp, Pwhite(0.3, 1), \out, 4, \st, Pwhite(13, 8), \rl, Pwhite(1, 2), \pos, Pwhite(0, 0.7), \dur, Pwhite(11, 25), \lag, 0) ).play;
Pdef(\rocks, Pbind(\instrument, \sampleNarcodeStrPZ, \buf, ~buffers['building']['rocks'], \amp, Pwhite(0.2, 0.7), \out, 6, \st, Pwhite(13, 8), \rl, Pwhite(8, 2), \pos, Pwhite(0, 0.4), \dur, Pwhite(25, 20), \lag, 0, \rate, Pwhite(0.5, 1)) ).play;
Pdef(\wood, Pbind(\instrument, \sampleNarcodeStrPZ, \buf, ~buffers['building']['wood'], \amp, Pwhite(0.1, 0.3), \out, Pwhite(0, 6), \st, Pwhite(3, 8), \rl, Pwhite(1, 2), \pos, Pwhite(0, 0.7), \dur, Pwhite(15, 20), \lag, 0) ).play;


Pdef(\stream1, Pbind(\instrument, \sampleNarcodeStrPZ, \buf, ~buffers['building']['water2'], \amp, 0.5, \out, 0, \st, Pwhite(3, 18), \rl, Pwhite(1, 2), \pos, Pwhite(0, 0.7), \dur, Pwhite(5, 2), \lag, 0) ).play; // rain
Pdef(\stream2, Pbind(\instrument, \sampleNarcodeStrPZ, \buf, ~buffers['building']['stream'], \amp, 0.65, \out, 4, \st, Pwhite(3, 18), \rl, Pwhite(1, 2), \pos, Pwhite(0, 0.7), \dur, Pwhite(5, 2), \lag, 0) ).play; // stream

// live coding
Pdef(\1, Pbind(\instrument, \sampleNarcodeStrPZ, \buf, ~buffers['building']['water1'], \amp, Pwhite(0.3, 1), \out, 0, \st, Pwhite(11, 13), \rl, Pwhite(1, 2), \pos, Pwhite(0, 0.7), \dur, Pwhite(7, 2), \lag, 0) ).play;
Pdef(\2, Pbind(\instrument, \sampleNarcodeStrPZ, \buf, ~buffers['building']['water3'], \amp, Pwhite(0.5, 1), \out, 2, \st, Pwhite(13, 18), \rl, Pwhite(1, 2), \pos, Pwhite(0, 0.7), \dur, Pwhite(3, 1), \lag, 0) ).play;
Pdef(\3, Pbind(\instrument, \sampleNarcodeStrPZ, \buf, ~buffers['building']['water3'], \amp, Pwhite(0.3, 1), \out, 4, \st, Pwhite(13, 8), \rl, Pwhite(1, 2), \pos, Pwhite(0, 0.7), \dur, Pwhite(1, 5), \lag, 0) ).play;
Pdef(\rocks, Pbind(\instrument, \sampleNarcodeStrPZ, \buf, ~buffers['building']['rocks'], \amp, Pwhite(0.2, 0.7), \out, 6, \st, Pwhite(13, 8), \rl, Pwhite(8, 2), \pos, Pwhite(0, 0.4), \dur, Pwhite(5, 10), \lag, 0, \rate, Pwhite(0.5, 1)) ).play;
Pdef(\wood, Pbind(\instrument, \sampleNarcodeStrPZ, \buf, ~buffers['building']['wood'], \amp, Pwhite(0.1, 0.3), \out, Pwhite(0, 6), \st, Pwhite(3, 8), \rl, Pwhite(1, 2), \pos, Pwhite(0, 0.7), \dur, Pwhite(15, 10), \lag, 0) ).play;


Pdef(\stream1, Pbind(\instrument, \sampleNarcodeStrPZ, \buf, ~buffers['building']['water2'], \amp, 0.5, \out, 0, \st, Pwhite(3, 18), \rl, Pwhite(1, 2), \pos, Pwhite(0, 0.7), \dur, Pwhite(5, 2), \lag, 0) ).play; // rain
Pdef(\stream2, Pbind(\instrument, \sampleNarcodeStrPZ, \buf, ~buffers['building']['stream'], \amp, 0.65, \out, 4, \st, Pwhite(3, 18), \rl, Pwhite(1, 2), \pos, Pwhite(0, 0.7), \dur, Pwhite(5, 2), \lag, 0) ).play; // stream

Pdef.all.do{|p| p.stop ; }