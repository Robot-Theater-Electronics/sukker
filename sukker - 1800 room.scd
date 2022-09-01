// 1800

t.tempo = 1.3;
~bfreq = 1895;

Ndef(\delay1, {1*CombN.ar(Resonz.ar(LPF.ar(WhiteNoise.ar(0.2), LFNoise1.kr(2).range(~bfreq/4, ~bfreq)) ring2: In.ar(~busfx1).distort, (1/2)*LFNoise0.kr(1/3).range(~bfreq/4, ~bfreq*4).lag(2), 0.3), 0.2, 0.4, 8) }).play(0,6, addAction: \addToTail);
Ndef(\delay1).fadeTime_(0);

// 1940's freq
Ndef(\blackFreq, {1*SinOsc.ar([~bfreq * Line.kr(1/24, 1/4, 20), ~bfreq/2 * Line.kr(1/24, 1, 20)])*LFPulse.ar(~bfreq/48/2) * 0.3 * LFNoise1.kr(1/4).range(0, 1)}).play(~busfx1,2, addAction: \addToHead);
Ndef(\blackFreqB, {2*SinOsc.ar([~bfreq * Line.kr(1/8, 1/16, 2), ~bfreq/2 * Line.kr(1/24, 1/4, 2)])*LFPulse.ar((~bfreq/48)/2) * 0.3 * LFNoise1.kr(1).range(0.2, 1)}).play(~busfx1,2,addAction: \addToHead);

Ndef(\blackFreq).fadeTime_(2);
Ndef(\blackFreqB ).fadeTime_(2);

Ndef(\blackFreq).stop(8);
Ndef(\blackFreqB).stop(8);
Ndef(\delay1).stop(8);

~steam =  {|in, amp=0.1, at=0.1, rl=1| {amp*Convolution.ar(In.ar(in), BPF.ar(WhiteNoise.ar(1), LFNoise1.kr(1).range([120, ~bfreq/2], ~bfreq*3/2)),512*2) * EnvGen.kr(Env.perc(at, rl), doneAction:2)}.play(outbus:~busfxLead) }; // LFNoise1.kr(1/4).range(0.01, 0.7)
Ndef(\verb, {1*Compander.ar(CombN.ar(FreeVerb.ar(In.ar(~busfxLead), 0.3), 1, 0.6, 1), CombN.ar(FreeVerb.ar(In.ar(~busfxLead), 0.3), 1, 0.6, 1), 0.01, 1, 0.5, 0.002) }).play(0,2, addAction: \addToTail);
~steam.(0.1, 0.1.rrand(2), 1.rrand(3))

p.ignite;

~in1 = Bus.audio(s, 2);
~in2 = Bus.audio(s, 2);
~in3 = Bus.audio(s, 2);
~in4 = Bus.audio(s, 2);


// atmos
p.dict['prison'] = { PZ_layer(x, ~buffers['prison'], ~in1, 1, {-1.rrand(1)}, {0.1.rrand(1)}, {1.rrand(0.1)}, 1).rhythm(1,1,0,[0,2]) };
p.dict[0] = { PZ_layer(~steam, ~in1, 1, {0.1.rrand(1)}, {1.rrand(4)}).rhythm(1,0,1,0) };

p.dict['noise'] = { PZ_layer(x, ~buffers['radio']['noise'], ~in2, 0.2, {-1.rrand(1)}, {0.1.rrand(1)}, 1, {3.rrand(0.1)}).rhythm(1,1,0,[0,2]) };
p.dict[1] = { PZ_layer(~steam, ~in2, 1, {0.1.rrand(2)}, {0.1.rrand(4)}).rhythm([0,1],[0,1],0,[0,1]) };

p.dict['sunra'] = { PZ_layer(x, ~buffers['sunra']['other'], ~in3, 0.2, -1.rrand(1), {0.1.rrand(0.9)}, {3.rrand(0.1)}, 1).rhythm(1,1,1,0) };
p.dict[2] = { PZ_layer(~steam, ~in3, 1, {0.1.rrand(2)}, {0.1.rrand(4)}).rhythm(1,[0,2],2,[0,2]) };

p.dict['wood'] = { PZ_layer(x, ~buffers['building']['wood'], 2, 0.2, -1.rrand(1), {0.1.rrand(0.9)}, {3.rrand(0.1)}, 1).rhythm(1,1,1,0) };

p.dict['noise2'] = { PZ_layer(x, ~buffers['radio']['noise'], ~in4, 0.2, 1, 0.2, 10, {3.rrand(0.1)}).rhythm(1) };
p.dict[3] = { PZ_layer(~steam, ~in4, 1, {0.1.rrand(2)}, {0.1.rrand(4)}).rhythm([0,1],[0,1],0,[0,1]) };


p.dict=();

// beat
p.dict['prison'] = { PZ_layer(x, ~buffers['prison'], ~in1, 1, {-1.rrand(1)}, {0.1.rrand(1)}, {1.rrand(0.1)}, 1).rhythm(1,1,0,[0,2]) };
p.dict[0] = { PZ_layer(~steam, ~in1, 1, {0.1.rrand(1)}, {1.rrand(0.4)}).rhythm(1,0,1,[0,2]) };

p.dict['noise'] = { PZ_layer(x, ~buffers['radio']['noise'], ~in2, 0.2, {-1.rrand(1)}, {0.1.rrand(1)}, 1, {3.rrand(0.1)}).rhythm(1,1,0,[0,2]) };
p.dict[1] = { PZ_layer(~steam, ~in2, 1, {0.1.rrand(2)}, {0.1.rrand(0.2)}).rhythm([0,1],[0,1],0,[0,1]) };

p.dict['sunra'] = { PZ_layer(x, ~buffers['sunra']['other'], ~in3, 0.2, -1.rrand(1), {0.1.rrand(0.9)}, {3.rrand(0.1)}, 1).rhythm(1,4,2,4) };
p.dict[2] = { PZ_layer(~steam, ~in3, 1, {0.1.rrand(2)}, {0.1.rrand(1)}).rhythm(1,[0,2],2,[0,2]) };

p.dict['wood'] = { PZ_layer(x, ~buffers['building']['wood'], 2, 0.2, -1.rrand(1), 0.2, {0.2.rrand(0.1)}, 1).rhythm(0,[0,0,0,1],2,[0,1]) };

p.dict['noise2'] = { PZ_layer(x, ~buffers['radio']['noise'], ~in4, 0.5, 1, 0.2, 3, {3.rrand(0.5)}).rhythm(4,4,4,4) };
p.dict[3] = { PZ_layer(~steam, ~in4, 1, 0.1, {0.1.rrand(0.3)}).rhythm(4,2,2,2) };


// grieg
~radioT = Pslide(Array.series(14, 0.1, 0.05).stutter(4), inf, 2, 1).asStream;
~vocals = Pslide(Array.series(18, 0.1, 0.05).stutter(3), inf, 2, 1).asStream;
~piano = Pslide(Array.series(18, 0.1, 0.05).stutter(1), inf, 2, 1).asStream;
~stutter = Pwhite(0, 0.9).stutter(4).asStream;
~stutterA = Pwhite(0, 0.9).stutter(4).asStream;
~stutterB = Pwhite(0, 0.9).stutter(4).asStream;

p.dict['grieg1'] = { PZ_layer(x, ~buffers['grieg'], 0, 1, {-1.rrand(1)}, ~radioT, {1.rrand(0.1)}+0, 1).rhythm(1,1,0,[0,2]) };

p.dict['grieg2'] = { PZ_layer(x, ~buffers['grieg'], 2, 0.6, {-1.rrand(1)}, ~vocals, {1.rrand(3)}+0, 1).rhythm(1,0,1,[1,1]) };

p.dict['grieg3'] = { PZ_layer(x, ~buffers['grieg'], 4, 0.5, -1.rrand(1), ~piano, {3.rrand(0.1)}+0, 1).rhythm(1,4,2,4) };

p.dict['grieg5'] = { PZ_layer(x, ~buffers['grieg'], 0, 0.5, -1.rrand(1), ~stutter, {0.1.rrand(1)}+0, 1).rhythm(4,4,4,4) };

p.dict['grieg5a'] = { PZ_layer(x, ~buffers['grieg'], 0, 0.6, -1.rrand(1), ~stutterA, {0.1.rrand(1)}+0, 1).rhythm(4,4,4,4) };

p.dict['grieg5b'] = { PZ_layer(x, ~buffers['grieg'], 0, 0.6, -1.rrand(1), ~stutterB, {0.1.rrand(1)}+0, 1).rhythm([0,2],[0,2],[0,2],[0,2]) };

// labrador
p.dict['l1'] = { PZ_layer(x, ~buffers['labrador'], 0, 1, {-1.rrand(1)}, ~radioT, {1.rrand(0.1)}+4, 1).rhythm(1,0,0,[0,2]) };
p.dict['l2'] = { PZ_layer(x, ~buffers['labrador'], 2, 0.6, {-1.rrand(1)}, ~vocals, {1.rrand(3)}+4, 1).rhythm(0,0,1,0) };

t.tempo = 0.4


p.dict['grieg5b'] = ();

p.dict = ();


t.tempo = 0.8;