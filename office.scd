// office

// B-Frequency:

~bfreq = 2022;

Ndef(\delay1, {4*GVerb.ar(CombN.ar(In.ar(~busfxLead).distort, 0.2, LFNoise1.kr(~bfreq/72/2).range(0.02022, 1), 3).lag(0.1), 42, 4) }).play(7,1);
Ndef(\delay1).fadeTime_(2);
Ndef(\blackFreq).fadeTime_(2);
Ndef(\blackFreq, {1*SinOsc.ar([~bfreq * Line.kr(1/24, 1/2, 18), ~bfreq/2 * Line.kr(1/24, 1, 12)])*LFPulse.ar(~bfreq/48/2) * 0.3 * LFNoise1.kr(~bfreq/48).range(0, 1)}).play(~busfxLead,2,addAction: \addToHead);
Ndef(\blackFreqB, {1*SinOsc.ar([~bfreq * Line.kr(1/24, 1/4, 20), ~bfreq/2 * Line.kr(1, 1/8, 20)])*LFNoise0.kr(~bfreq/48/16) * 0.3 * LFNoise1.kr(~bfreq/48/2).range(0, 1)}).play(~busfxLead,2,addAction: \addToHead);

Ndef(\blackFreqB).stop(8);

// args: buf, out, amp, trig, pos, st, rate;
p.beats = 8;
p.ignite;

~accomp = Place([0.85, 0.85!2++[0.504], 0.85, 0.86, 0.87, 0.85!4++0.504], inf).asStream;
~vocals = Pslide(Array.series(18, 0.1, 0.05).stutter(2), inf, 2, 1).asStream;

p.dict['vocals'] = { PZ_layer(x, ~buffers['office']['original'], 4, 1, 0, {0.1.rrand(0.9)}, 8, 0.9).rhythm([0,1].choose,0,0,0, 1) };

p.dict['capella'] = { PZ_layer(x, ~buffers['office']['vocals'], ~busVoice, 1, 0, ~vocals, {0.2.rrand(5)}, 1).rhythm(1,1,1,0,0,1,1,0) };
p.dict['capella2'] = { PZ_layer(x, ~buffers['office']['vocals'], ~busVoice, 1, 0, 0.3, {0.2.rrand(2)}, 1).rhythm(1,[0,0,0,1],[1,1],0,0,[0,0,0,1],[1,1],0) };

p.dict['accomp'] = { PZ_layer(x, ~buffers['office']['accomp'], 0, 0.9, 0, ~accomp, {5.rrand(0.2)}, 1).rhythm(1,0,1,0,1,0,1,0) };
p.dict['accomp2'] = { PZ_layer(x, ~buffers['office']['accomp'], ~busfx1, 1, 0, ~accomp, {5.rrand(0.2)}, 1).rhythm([0,1],[0,1],0,0,0,4,0,[0,1,0,1]) };

p.dict['accomp3'] = { PZ_layer(x, ~buffers['office']['accomp'], 0, 0.9, 0, 0.504, {5.rrand(23)}, 1).rhythm(4,2,[0,1,1,1],2,[1,1,2,4],[0,1],1,2) };


Ndef(\hp, {1.5*GVerb.ar(BPF.ar(In.ar(~busVoice).distort, 1899, 0.8), 180, 0.3, 0) }).play(2,2);
Ndef(\mp, {1*BPF.ar(In.ar(~busfx1).distort, 1050, 1) }).play(0,2);
Ndef(\lp, {3*LPF.ar(In.ar(~busfx1).distort, 400, 1) }).play(0,2);
Ndef(\mp2, {4*BPF.ar(In.ar(~busfx1).distort, 770, 1) }).play(0,2);

t.tempo = 0.6;
// t.tempo = 2;

p.dict['accomp'] = ()

