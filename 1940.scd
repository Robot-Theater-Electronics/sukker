// 1940 // UFO // time machine // afro-futurism

~bfreqS = 1939;
~bfreqE = 1940;

Ndef(\delay1, {2*CombN.ar(Resonz.ar(In.ar(~busfx1).distort, (1/2)*LFSaw.kr(1).range(~bfreqS, ~bfreqE), 0.3), 0.2, 0.4, 8) }).play(7,1, addAction: \addToTail);
Ndef(\delay1).fadeTime_(2);

 // 1940's freq
Ndef(\blackFreq, {1*SinOsc.ar([~bfreqS * Line.kr(1/24, 1, 20), ~bfreqS/2 * Line.kr(1/24, 1, 20)])*LFPulse.ar(~bfreqS/48/2) * 0.3 * LFNoise1.kr(1/4).range(0, 1)}).play(~busfx1,2, addAction: \addToHead);
Ndef(\blackFreqB, {1*SinOsc.ar([~bfreqE * Line.kr(1/24, 1/12, 20), ~bfreqE/2 * Line.kr(1/24, 1/16, 20)])*LFPulse.ar(~bfreqE/48/2) * 0.3 * LFNoise1.kr(1/4).range(0, 1)}).play(~busfx1,2,addAction: \addToHead);

Ndef(\blackFreq).stop(8);
Ndef(\blackFreqB ).stop(8);

~radar =  {|amp=0.1| {amp*Blip.ar([~bfreqE, ~bfreqS], 4).sum * EnvGen.kr(Env.perc)}.play(outbus:~busfxLead) };
Ndef(\radar, {1*CombN.ar(FreeVerb.ar(In.ar(~busfxLead), 0.6), 1, 0.8, 9) }).play(0,1, addAction: \addToTail);
~radar.(0.1)

// radio
p.ignite;
~radioT = Pslide(Array.series(14, 0.1, 0.05).stutter(2), inf, 2, 1).asStream;
~vocals = Pslide(Array.series(18, 0.1, 0.05).stutter(3), inf, 2, 1).asStream;
~piano = Pslide(Array.series(18, 0.1, 0.05).stutter(1), inf, 2, 1).asStream;

p.dict[0] = { PZ_layer(x, ~buffers['radio']['40s'], 0, 0.4, -1.rrand(1), {~radioT}, {1.rrand(3)}, 1).rhythm(1,0,0,1) };

p.dict[1] = { PZ_layer(x, ~buffers['annebrown']['piano'], 4, 1.5, {-1.rrand(1)}, ~piano, 8, 1).rhythm(1,0,0,0) };

p.dict[2] = { PZ_layer(x, ~buffers['annebrown']['vocals'], 2, 0.0.05, -1.rrand(1), {~vocals}, 2, 1).rhythm(1,0,[1,1, 1],0) };

p.dict[3] = { PZ_layer(x, ~buffers['annebrown']['vocals'], 2, 0.85, {-1.rrand(1)}, 0.1, {1.rrand(2)}, 1).rhythm(0,1,0,1) };

p.dict[5] = { PZ_layer(x, ~buffers['prison'], 6, 0.07, {-1.rrand(1)}, {0.1.rrand(1)}, 2, 1).rhythm(0,1,0,1) };

p.dict[6] = { PZ_layer(x, ~buffers['radio'][['tunning', 'noise'].choose], 2, {0.1.rrand(0.4)}, {-1.rrand(1)}, {0.1.rrand(1)}, {0.4.rrand(0.8)}, 1).rhythm(0,3,0,1) };

p.dict[7] = { PZ_layer(~radar, 0.1.rrand(0.25)).rhythm(0,0,0, {2.rand.postln}.() ) };

p.dict[2] = ();

p.dict=();

t.tempo = 0.8;

p.dict[1] = { PZ_layer(x, ~buffers['annebrown']['piano'], 4, 0.03, {-1.rrand(1)}, ~piano, 8, 1).rhythm(1,0,0,0) };