// 1600

~bfreq = 1692;

t.tempo=40/60;

// black frequency
Ndef(\delay1, {2*CombN.ar(LPF.ar(In.ar(~busfx1), (~bfreq/4)*LFNoise1.kr((~bfreq/48)/60).range(1, 1/2), 0.1), 0.2, 0.4, 8) }).play(7,1, addAction: \addToTail);
Ndef(\delay1).fadeTime_(2);

Ndef(\blackFreq, {1*Blip.ar([~bfreq * XLine.kr(1/24, 1/16, 10), ~bfreq/2 * LFTri.kr(1/~bfreq).range(1/24, 1/8)], LFTri.kr(1/(~bfreq/48)).range(3, ~bfreq/16)) * 0.5 * LFNoise1.kr(1/4).range(0, 1)}).play(~busfx1, addAction: \addToHead);
Ndef(\blackFreqB, {1*Blip.ar([~bfreq * XLine.kr(1/24, 1/32, 6), ~bfreq/2 * XLine.kr(1/24, 1/32, 6], LFTri.kr(1/(~bfreq/60)).range(3, ~bfreq/16)) * 0.5 * LFNoise1.kr(1/8).range(0, 1)}).play(~busfx1, addAction: \addToHead);

Ndef(\blackFreqB).fadeTime_(4);
Ndef(\blackFreq).fadeTime_(4);
Ndef(\blackFreqB).stop(16);Ndef(\blackFreq).stop(16);
Ndef(\blackFreqB).clear;Ndef(\blackFreq).clear;

// melody synth:
(
~plantasia = Environment[
  'lead' -> Environment[
  'init' -> {|self, note=1, amp=0.1, vib=4, port=0.1, scale=\major, oct=1, root=60, id=\lead|
   var key; if (~synths.includesKey(id)) { key = (id.asString ++ ~synths.size).asSymbol; } { key = id; };
   { s.sync; ~synths[key] = {|note=1, amp=0, vib=4, port=1|
    Saw.ar([note.lag(port), (note+0.1.rrand(4)).lag(0.4);]).distort*amp.lag(3)*LFTri.kr(vib)}.play(outbus:~busfxLead);
   s.sync; ~synths[key].set(\note, Scale.at(scale).degreeToFreq(note, root.midicps, oct).lag(port), \amp, amp, \vib, vib, \port, port);}.fork; },

  'set' -> {|self, note=1, amp=0.1, vib=4, port=0.1, scale=\major, oct=1, root=60, id=\lead| ~synths[id].set(\note, Scale.at(scale).degreeToFreq(note, root.midicps, oct).lag(port), \amp, amp.lag(0.2), \vib, vib.lag(0.1), \port, port); },

  'bye' -> {|self, rel=6, id=\lead| ~synths[id].release(rel); ~synths.removeAt(id) }
 ].know = true,

 'accomp' -> Environment[
  'init' -> {|self|
   {|note=1, amp=0.1, vib=4, port=0.1, rl=1, scale=\major, oct=1, root=60|
    var freq = Scale.at(scale).degreeToFreq(note, root.midicps, oct).lag(port);
    // freq.cpsname.postln;
     {
     Splay.ar([Saw.ar([freq, freq+0.1.rrand(4)]*Line.kr(1.5, 1, port))])*amp.lag(3)*LFTri.kr(vib).range(0.2, 1)*EnvGen.kr(Env.perc(0.07, rl), doneAction:2)}.play(outbus: ~busfx1); } },
  'bye' -> {|self, rel=6, id=\accomp| ~synths.removeAt(id) }
 ].know = true,

 'sampler' -> Environment[
  'init' -> {|self|
    var key; if (~synths.includesKey(\sampler)) { key = (\sampler.asString ++ ~synths.size).asSymbol; } { key = \sampler; };
   {
     ~synths[key] = {|buf=1, amp=0, trig=0, pos=0, rate=1|
     PlayBuf.ar(2, buf, BufRateScale.kr(buf)*rate, Impulse.kr(trig), (BufFrames.kr(buf)*pos).lag(0.3), doneAction:0).sum*amp}.play(outbus: ~busVoice ); } },
  'set' -> {|self| {|buf, amp, trig, pos, rate, out=0|
   if (trig > 0) {
    {
    ~synths[\sampler].set(\buf, buf, \amp, amp, \trig, trig, \pos, pos, \rate, rate);
     1.wait;
     ~synths[\sampler].set(\trig, 0);
    }.fork;
   } {
   ~synths[\sampler].set(\buf, buf, \amp, amp, \trig, trig, \pos, pos, \rate, rate);
   }
   } },
  'bye' -> {|self, rel=6, id=\sampler| ~synths[id].release(rel); ~synths.removeAt(id) }
 ].know = true;

].know = true;
);


// counterpoint

// comments:
Could the music soar more
Could the noise that interrupts be more pronounced
starts around 0.4 and finishes at 0.41 (audio)

~prog = Pseq([\minor!8].flatten.stutter(6), inf).asStream;
~chord = Prand([0,2,4,6,4,2],inf).asStream;
~root = Pseq((["f3".namemidi, "Bb3".namemidi].stutter(12)!4).flatten ++ ["f3".namemidi, "c3".namemidi].stutter(12)++["ab3".namemidi, "g3".namemidi].stutter(12), inf).asStream; //v1 = 13

// v counterpoint 5 voices
p.dict[0] = { PZ_layer(~plantasia.accomp.init, ~chord, 0.12, {1.rrand(8)}, 0.01, {t.tempo*1.rrand(0.3)+0}, ~prog, 1, ~root).rhythm([1,0,0,1],[1,0,0,1],[1,0,0,1],[1,0,0,1]) };
p.dict[1] = { PZ_layer(~plantasia.accomp.init, ~chord, 0.12, {1.rrand(6)}, 0.01, {t.tempo*1.rrand(0.3)+0}, ~prog, -1, ~root).rhythm([1,2],1,[0,2],1) };
p.dict[2] = { PZ_layer(~plantasia.accomp.init, ~chord, 0.12, {1.rrand(4)}, 0.01, t.tempo*8.rrand(2)+0, ~prog, -2, ~root).rhythm(1,0,1,0) };
p.dict[3] = { PZ_layer(~plantasia.accomp.init, ~chord, 0.2, {1.rrand(8)}, 0.01, t.tempo*16.rrand(4)+7, ~prog, -3, ~root).rhythm(1,0,0,[0,2.rand]) };
p.dict[4] = { PZ_layer(~plantasia.accomp.init, ~chord, 0.1, {1.rrand(8)}, 0.01, {t.tempo*4.rrand(0.1)+0}, ~prog, 2, ~root).rhythm(0.rrand(1),2.rrand(0),1.rrand(0),2.rrand(0)) };

// lc
p.dict[0] = { PZ_layer(~plantasia.accomp.init, ~chord, 0.12, {1.rrand(8)}, 0.01, {t.tempo*0.1.rrand(0.1)}, ~prog, -3, ~root).rhythm(1) };
p.dict[1] = { PZ_layer(~plantasia.accomp.init, ~chord, 0.12, {1.rrand(6)}, 0.01, {t.tempo*0.rrand(0.1)}, ~prog, -3, ~root).rhythm(1) };
p.dict[2] = { PZ_layer(~plantasia.accomp.init, ~chord, 0.12, {1.rrand(4)}, 0.01, t.tempo*0.rrand(0.1), ~prog, -4, ~root).rhythm(1) };
p.dict[3] = { PZ_layer(~plantasia.accomp.init, ~chord, 0.2, {1.rrand(8)}, 0.01, t.tempo*0.rrand(0.1), ~prog, -3, ~root).rhythm(1) };
p.dict[4] = { PZ_layer(~plantasia.accomp.init, ~chord, 0.1, {1.rrand(8)}, 0.01, {t.tempo*0.rrand(0.1)}, ~prog, 2, ~root).rhythm(1) };

~plantasia.sampler.init.();
~plantasia.sampler.set.(~buffers['ruth'], 1, 0, 0.9.rand);
~plantasia.sampler.bye(2);
p.dict['5']=();
p.ignite


p.dict = ();

PZ_layer.debug = true;

// fx

~fx1 = {|amp=0.3, revtime=1| amp*GVerb.ar(In.ar(~busfx1), 100, revtime) * Line.kr(0,amp, 5) }.play(outbus:2, addAction: \addToTail);
~fx1.set(\amp, 0.4, \revtime, 1)
~fx1.release(1);

~fx1L = {|amp=0.1, revtime=1| GVerb.ar(In.ar(~busfxLead), 100, revtime) * Line.kr(0,amp, 5) }.play(outbus: 4, addAction: \addToTail);
~fx1L.release(1);

~fx2 = {|amp=0.7, deltime=0.25, dec=10, rate=1, q=0.3| amp*CombN.ar(BPF.ar(In.ar(~busfx1), 500, 0.7), 0.2, deltime.lag(0.2), dec) * Line.kr(0, amp, 5) }.play(outbus:3, addAction: \addToTail);
~fx2.set(\amp, 0.4, \deltime, t.tempo/4, \dec, 30);
~fx2.release(2);


// NOISE:
~fx2L = {|amp=0.1, deltime=0.25, dec=10| amp*CombN.ar(In.ar(~busfxLead), 0.2, deltime.lag(0.2), dec) * Line.kr(0, amp, 5) }.play(outbus:4, addAction: \addToTail);
~fx2L.set(\amp, 1, \deltime, 0.5, \dec, 12);
~fx2LR = {|amp=0.01, deltime=0.125, dec=2| amp*CombN.ar(In.ar(~busfxLead), 0.2, deltime.lag(0.2), dec) * Line.kr(0, amp, 5) }.play(outbus:5, addAction: \addToTail);
~fx2LR.set(\amp, 2, \dec, 10);
~fx2L.release

~fxVG = {|amp=0.3, revtime=1, room=140| amp*Splay.ar(GVerb.ar(In.ar(~busVoice), room, revtime), 0) }.play(outbus:4, addAction: \addToTail);
~fxVG.set(\revtime, 2, \room, 70, \amp, 0.4);
~fxVG.release(6)

~fxV = {|amp=0.3| amp*Splay.ar(In.ar(~busVoice), 0) }.play(outbus:4, addAction: \addToTail);
~fxV.set(\amp, 0.1);
~fxV.release(5);
~fxClean = {|amp=0.3, cf=500| amp*Splay.ar(BPF.ar(In.ar(~busfx1), cf, 0.7), 0) }.play(outbus:0, addAction: \addToTail);
~fxClean.set(\amp, 0.02);
~fxClean.release

~noise = {|amp=0.1, rate=1, rl=1, cf=120, q=1| { BPF.ar(BrownNoise.ar(amp*LFTri.kr(1)), cf, q)* LFNoise0.kr(rate) * EnvGen.kr(Env.perc(0.01, releaseTime:rl), doneAction:2) }.play(outbus:~busfxLead); }

~cf = Pseq(Array.series(100, 480, 25), inf).asStream;
~q = Pseq(Array.series(99, 1, -0.0110), inf).asStream;
p.dict['noise'] = { PZ_layer(~noise, 1.5, 3, {0.2.rrand(7)}, {222.rrand(~bfreq)}, {0.2.rrand(0.8)}).rhythm(4,[0,4],2,[1,0,1,2]) };

p.dict = ();

//
~radioT = Pslide(Array.series(14, 0.1, 0.05).stutter(2), inf, 2, 1).asStream;
 p.dict['narrator'] = { PZ_layer(x, ~buffers['narrator'], ~busfx1, 1, {-1.rrand(1)}, {~radioT}, {1.rrand(3)}, 1).rhythm(1,1,1,1) };
 p.dict['narrator2'] = { PZ_layer(x, ~buffers['narrator'], ~busfx1, 1, {-1.rrand(1)}, {~radioT}, {1.rrand(3)}, 0.8).rhythm(0,1,0,{1.rrand(2)}.()) };
 p.dict['narrator3'] = { PZ_layer(x, ~buffers['narrator'], 6, 1.5, {-1.rrand(1)}, {~radioT}, {1.rrand(3)}, {0.6.rrand(1.2)}).rhythm(0,3,0,0) };

 p.dict['prison'] = { PZ_layer(x, ~buffers['prison'], ~busfx1, 0.02, {-1.rrand(1)}, {0.1.rrand(1)}, 2, 1).rhythm(0,1,0,1) };


p.dict['sn'] = { PZ_layer(~cl, 6, 0.4).rhythm(0,1,0,1) };
p.dict['hh'] = { PZ_layer(~hh, 7, 0.4).rhythm(2,1,0,[0,0,0,[1,0].choose]) };

// v3 (intstrumental and faster
p.dict['cl'] = ();
p.dict['hh'] = ();
p.dict['hh'] = { PZ_layer(~hh, 7, 0.1).rhythm(2,2,2,2) };

p.dict['bd'] = ();

Tdef.all.do{|t| t.stop}; p.dict=();




