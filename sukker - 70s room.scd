// sugar 70s room

~synths = ();
p = PZ_machine(s);
p.ignite;


// 1. plantasia

// melody synth:
(
~plantasia = Environment[
  'lead' -> Environment[
  'init' -> {|self, note=1, amp=0.1, vib=4, port=0.1, scale=\major, oct=1, root=60, id=\lead|
   var key; if (~synths.includesKey(id)) { key = (id.asString ++ ~synths.size).asSymbol; } { key = id; };
   { s.sync; ~synths[key] = {|note=1, amp=0, vib=4, port=1|
    SinOsc.ar([note.lag(port), (note+0.1.rrand(4)).lag(0.4);]).distort*amp.lag(3)*LFTri.kr(vib)}.play(outbus:~busfxLead);
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
     Splay.ar([SinOsc.ar([freq, freq+0.1.rrand(4)]*Line.kr(1.5, 1, port))])*amp.lag(3)*LFTri.kr(vib).range(0.2, 1)*EnvGen.kr(Env.perc(0.07, rl), doneAction:2)}.play(outbus: ~busfx1); } },
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


Tdef(\l, {
 loop{
  ~plantasia.lead.init(1, 0.5, 4, 3, \major, [1, -2, -4].choose, 60);
  2.wait;
~plantasia.lead.set(2, 0.4, 8.rrand(2), 4, \minor, [1,2], 65);
  2.wait;
~plantasia.lead.bye(2);
  (12*4).wait;
 }
}).play;

~plantasia.accomp.init.(~notes.(), 0.2, 8, 0.2, 0.1, \minor, 2, "f0".namemidi);
~plantasia.accomp.bye


~fm7 = ([1,3,5,7]!2).flatten;
~bbm7 = ([1,3,5,7]!2).flatten;
~c7 = ([2,4,5,7]!2).flatten;

~prog = Pseq([\minor!8, \mixolydian, \major, \locrian].flatten.stutter(6), inf).asStream;
~chord = Pseq([0,2,4,6,4,2],inf).asStream;
~root = Pseq((["f3".namemidi, "Bb3".namemidi].stutter(12)!4).flatten ++ ["f3".namemidi, "c3".namemidi].stutter(12)++["ab3".namemidi, "g3".namemidi].stutter(12), inf).asStream; //v1 = 13
// v1
p.dict['accomp'] = { PZ_layer(~plantasia.accomp.init, ~chord, 0.12, 1, 0.01, {1.rrand(0.3)}, ~prog, [-1, 1], ~root).rhythm(4,2,4,2) };
// ruth reese
p.dict['ruth'] = { PZ_layer(~plantasia.sampler.set, ~buffers['ruth'], 1, [0!2, t.tempo, t.tempo*2].flatten.choose, 0.9.rand, 0.89).rhythm(1,0,0,0) };

~plantasia.sampler.init.();
~plantasia.sampler.set.(~buffers['ruth'], 1, 0, 0.9.rand);
~plantasia.sampler.bye(2);
p.dict=();
t.tempo=90/60

PZ_layer.debug = true;

// fx

~fx1 = {|amp=0.3, revtime=1| amp*GVerb.ar(In.ar(~busfx1), 100, revtime) * Line.kr(0,amp, 5) }.play(outbus:2, addAction: \addToTail);
~fx1.set(\amp, 0.01, \revtime, 1)
~fx1.release(1);
~fx1L = {|amp=0.1, revtime=1| GVerb.ar(In.ar(~busfxLead), 100, revtime) * Line.kr(0,amp, 5) }.play(addAction: \addToTail);
~fx1L.release(1);

~fx2 = {|amp=0.7, deltime=0.25, dec=10, rate=1, q=0.3| amp*CombN.ar(BPF.ar(In.ar(~busfx1), 500, 0.7), 0.2, deltime.lag(0.2), dec) * Line.kr(0, amp, 5) }.play(outbus:3, addAction: \addToTail);
~fx2.set(\amp, 0.4, \deltime, 0.25, \dec, 2);
~fx2.release(2);
~fx2L = {|amp=0.1, deltime=0.25, dec=10| CombN.ar(In.ar(~busfxLead), 0.2, deltime.lag(0.2), dec) * Line.kr(0, amp, 5) }.play(outbus:1, addAction: \addToTail);


~fxVG = {|amp=0.3, revtime=1, room=140| amp*Splay.ar(GVerb.ar(In.ar(~busVoice), room, revtime), 0) }.play(outbus:4, addAction: \addToTail);
~fxVG.set(\revtime, 2, \room, 70, \amp, 0.4);
~fxVG.release(6)

~fxV = {|amp=0.3| amp*Splay.ar(In.ar(~busVoice), 0) }.play(outbus:4, addAction: \addToTail);
~fxV.set(\amp, 0.1);
~fxV.release(5);
~fxClean = {|amp=0.3, cf=500| amp*Splay.ar(BPF.ar(In.ar(~busfx1), cf, 0.7), 0) }.play(outbus:0, addAction: \addToTail);
~fxClean.set(\amp, 0.02);
~fxClean.release

p.dict['bd'] = { PZ_layer(~bd, 7, 0.4).rhythm(1,[0,1],0,[0,0,0,1]) };
p.dict['cl'] = { PZ_layer(~cl, 6, 0.4).rhythm(0,0,0,1) };
p.dict['sn'] = { PZ_layer(~cl, 6, 0.4).rhythm(0,1,0,1) };
p.dict['hh'] = { PZ_layer(~hh, 7, 0.4).rhythm(2,1,0,[0,0,0,[1,0].choose]) };

// v3 (intstrumental and faster
p.dict['cl'] = ();
p.dict['hh'] = ();
p.dict['hh'] = { PZ_layer(~hh, 7, 0.1).rhythm(2,2,2,2) };

p.dict['bd'] = ();

Tdef.all.do{|t| t.stop}; p.dict=();


// FINAL VERSIONS:
// Ruth Reese + plantasia + rythmical (black frequency, log cutting) + 1970Hz

// v1 randomness
Tdef(\score, {
 Pdef(\p1, PmonoArtic(\sampleNarcodeStrP, \buf, ~buffers['plantasia']['other'], \amp, 1, \out, 0, \rate, 0.8, \trig, Pwhite(-1, 1), \pos, 0, \end, 0.1, \dur, Pseq([4, 1/2, 1/2], inf), \legato, Pwhite(0.1,1)) ).play;

16.wait;

 Pdef(\p2, PmonoArtic(\sampleNarcodeStrP, \buf, ~buffers['plantasia']['other'], \amp, 0.3, \out, 2, \rate, 0.8, \trig, Pwhite(-1, 1), \pos, 0.7, \end, 0.72, \dur, Pseq([1/2, 1/2, 1, 1, 4], inf), \legato, Pwhite(0.5, 0.8)) ).play;
 Pdef(\p1, PmonoArtic(\sampleNarcodeStrP, \buf, ~buffers['plantasia']['other'], \amp, 1, \out, 0, \rate, 0.8, \trig, Pwhite(-1, 1), \pos, Pwalk(Array.series(10,0,0.1), 0.1), \end, 1, \dur, Pseq([4, 1/2, 1/2], inf), \legato, Pwhite(0.1,1)) ).play;

20.wait;

Pdef(\p3, PmonoArtic(\sampleNarcodeStrP, \buf, ~buffers['plantasia']['synth1'], \amp, 0.2, \out, ~busfx1, \trig, Prand([0,1,2],inf), \start, Pwhite(0,0.9).stutter(3), \dur, Pseq([1], inf), \legato, 0.6 ) ).play;

20.wait;

Pdef(\p4, Pmono(\sampleNarcodeStrP, \buf, ~buffers['plantasia']['synth2'], \amp, 0.02, \out, 4, \trig, 0, \pos, Pwhite(0, 0.3), \dur, Pseq([1/4], inf), \lag, 2 ) ).play;

20.wait;
 Pdef(\ruth, PmonoArtic(\sampleNarcodeStrP, \buf, ~buffers['ruth']['vocals'], \amp, 1.5, \out, ~busfx1, \rate, 1, \trig, 0, \start, 0, \end, 1, \dur, 4, \legato, Pwhite(0.5, 1.2))).play;

 Ndef(\delay1, {2*CombN.ar(Resonz.ar(In.ar(~busfx1).distort, (1970/2)*LFSaw.kr(1).range(1, 1/4), 0.3), 0.2, 0.4, 8) }).play(7,1, addAction: \addToTail);
 Ndef(\delay1).fadeTime_(2);

 26.wait;
Pdef(\pb, PmonoArtic(\sampleNarcodeStrP, \buf, ~buffers['plantasia']['bass'], \amp, 1, \out, 5, \trig, Pwhite(0,1), \start, Pwhite(0.0, 1.0), \dur, Pseq([4], inf), \legato, Pwhite(0.1, 1) ) ).play;

16.wait;
Ndef(\blackFreq, {SinOsc.ar(1970/24)*LFPulse.ar(1970/48/2) * 0.3 * LFNoise1.kr(1/4).range(0, 1)}).play(2,1);

16.wait;

 // 1970's freq
Ndef(\blackFreq, {1*SinOsc.ar([1970 * Line.kr(1/24, 1, 20), 1970/2 * Line.kr(1/24, 1, 20)])*LFPulse.ar(1970/48/2) * 0.3 * LFNoise1.kr(1/4).range(0, 1)}).play(~busfx1,2);
Ndef(\blackFreqB, {1*SinOsc.ar([1970 * Line.kr(1/24, 1/12, 20), 1970/2 * Line.kr(1/24, 1/16, 20)])*LFPulse.ar(1970/48/2) * 0.3 * LFNoise1.kr(1/4).range(0, 1)}).play(~busfx1,2);

}).play;

Pdef.gui

Ndef(\blackFreq).stop(8);
Ndef(\blackFreqB ).stop(8);

// v2 beat
t.tempo = 0.6
// x = {arg buf, out=0, amp=1, trig=1, pos=0, st=1, rate=1; Synth(\sampleNarcodeStrPZ, [\buf, buf, \amp, amp, \out, out, \trig, trig, \pos, pos, \st, st, \rate, rate])};
y = Synth(\sampleNarcodeStrP, [\buf, ~buffers['plantasia']['other'], \amp, 0.4, \out, 0, \trig, 0, \pos, 0, \at, 1, \rate, 1]);
y.release(10);




p.dict[0] = { PZ_layer(x, ~buffers['plantasia']['other'], 0, 0.4, -1.rrand(1), 0.3, {1.rrand(2)}, 1).rhythm(1,0,0,1) };

p.dict[1] = { PZ_layer(x, ~buffers['plantasia']['synth1'], 0, 0.2, {-1.rrand(1)}, 0.3, 2, 1.5).rhythm(1,0,0,0) };

p.dict[2] = { PZ_layer(x, ~buffers['plantasia']['bass'], 2, 0.5, -1.rrand(1), [0.7,0.5].choose, 2, 1).rhythm(1,0,[0,1],0) };

p.dict[3] = { PZ_layer(x, ~buffers['sunra']['drums'], 4, 0.85, {-1.rrand(1)}, 0.1, {1.rrand(2)}, 1).rhythm(0,1,0,1) };

p.dict[4] = { PZ_layer(x, ~buffers['ruth']['vocals'], 6, 0.9, -1.rrand(1), {0.1.rrand(1)}, 3, 0.8.rrand(1)).rhythm(1,0,1,1) };

p.dict[5] = { PZ_layer(x, ~buffers['prison'], 6, 0.2, {-1.rrand(1)}, {0.1.rrand(1)}, 2, 1).rhythm(0,2,0,0) };

p.dict[0]=();p.dict[1]=();
p.dict[2]=();
p.dict[3]=();
p.dict[4]=();
p.dict[5]=();

p.dict[3] = { PZ_layer(x, ~buffers['sunra']['drums'], 0, 0.1, {-1.rrand(1)}, 0.1.rrand(0.8), {1.rrand(2)+2}, 1).rhythm(0,1,0,1) };
p.dict[4] = { PZ_layer(x, ~buffers['sunra']['vocals'], 6, 0.2, 0, 0, 3, 1).rhythm(2) };

p.dict[3]= ();p.dict[4]= ();

// drums impro sun-ra
p.dict[3] = { PZ_layer(x, ~buffers['sunra']['drums'], 4, 0.85, {-1.rrand(1)}, {0.1.rrand(0.8)}, {1.rrand(3)}, 1).rhythm(2,1,1,1) };

// drums impro sun-ra
p.dict[3] = { PZ_layer(x, ~buffers['sunra']['drums'], 4, 0.85, {-1.rrand(1)}, {0.1.rrand(0.9)}, {1.rrand(3)}, 1).rhythm(2,1,2,1) };
p.dict[4] = { PZ_layer(x, ~buffers['ruth']['vocals'], 6, 0.9, -1.rrand(1), {0.1.rrand(0.5)}, 4, 1).rhythm(1,0,0,0) };



p.dict=();
p.ignite;

Pdef(\p1, PmonoArtic(\sampleNarcodeStrP, \buf, ~buffers['plantasia']['other'], \amp, 1, \out, 0, \rate, 0.8, \trig, 1, \start, Pseries(0, 0.01), \end, 1, \dur, Pseq([1/2, 1/2, 4], inf), \legato, 1) ).play; // 0.7, 0.8 nice
Pdef(\pb, PmonoArtic(\sampleNarcodeStrP, \buf, ~buffers['plantasia']['bass'], \amp, 1, \out, 5, \trig, Pwhite(0,1), \start, Pwhite(0.0, 1.0), \dur, Pseq([4], inf), \legato, Pwhite(0.1, 1) ) ).play;
Pdef(\p2, PmonoArtic(\sampleNarcodeStrP, \buf, ~buffers['plantasia']['synth1'], \amp, 0.3, \out, 0, \trig, Prand([0,1,2],inf), \start, Pwhite(0,0.9).stutter(3), \dur, Pseq([3], inf), \legato, 1.2 ) ).play;
Pdef(\p3, PmonoArtic(\sampleNarcodeStrP, \buf, ~buffers['plantasia']['synth2'], \amp, 0.1, \out, 0, \trig, Pseq([0,1,2,4],inf), \start, Pwhite(0, 0.9), \dur, Pseq([1/4], inf), \legato, 1 ) ).play;
// black frequency:
Ndef(\blackFreq, {SinOsc.ar(1970/24)*LFPulse.ar(1970/48/2) * 0.3 * LFNoise1.kr(1/4).range(0, 1)}).play(2,1);
Ndef(\blackFreq).stop(6);
 Ndef(\blackFreq).fadeTime_(9);

// ruth
Pdef(\ruth, PmonoArtic(\sampleNarcodeStrP, \buf, ~buffers['ruth']['vocals'], \amp, 1.5, \out, ~busfx1, \rate, 1, \trig, Pwhite(-1,1), \start, 0, \end, 1, \dur, Pwhite(1,6), \legato, Pwhite(0.5, 1.2)) ).play;
Ndef(\delay, {2*CombN.ar(Resonz.ar(In.ar(~busfx1).distort, 1970*LFSaw.kr(1/4).range(1, 1/4), 0.2), 0.2, 0.4, 3) }).play(3,2);

Ndef(\blackFreq).clear;
~other.play;
~other2.play;



Ndef(\plantasia).stop
