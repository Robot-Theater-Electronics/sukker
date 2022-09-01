// init
s.waitForBoot{
// synths
	SynthDef(\sampleNarcodeStrP, {|out=0, at=0.1, rl=0.1, trig=0, rate=1, pos=0, end=1, amp=1, buf, gate=1, lag=0|
	var env = EnvGen.kr(Env.adsr(at, 0.2, 0.9, rl), gate, doneAction:2);
	var snd;
 var frames = BufFrames.kr(buf);
 snd = BufRd.ar(2, buf, Phasor.ar(trig,rate,frames*pos, frames*end, frames*pos.lag(0.2)).lag(lag), loop: 0, interpolation:4)*env;
	Out.ar(out, snd*amp);
}).add;

	SynthDef(\sampleNarcodeStrPZ, {|out=0, at=0.1, rl=0.1, trig=0, rate=1, pos=0, end=1, amp=1, buf, lag=0, st=0.1|
	var env = EnvGen.kr(Env.linen(at, st, rl), doneAction:2);
	var snd;
 var frames = BufFrames.kr(buf);
 snd = BufRd.ar(2, buf, Phasor.ar(trig,rate,frames*pos, frames*end, frames*pos.lag(0.2)).lag(lag), loop: 0, interpolation:4)*env;
	Out.ar(out, snd*amp);
}).add;

~buffers['annebrown'] = ();
~buffers['sunra'] = ();
~buffers['ruth'] = ();
~buffers['plantasia'] = ();
~buffers['radio'] = ();
~buffers['building'] = ();
~buffers['office'] = ();

~path = thisProcess.nowExecutingPath.dirname;
~buffers['ruth']['vocals'] = Buffer.read(s, ~path ++ "/samples/ruth reese/vocals.wav"); // 70's
~buffers['ruth']['piano'] = Buffer.read(s, ~path ++ "/samples/ruth reese/ruth reese piano.wav"); // 70's

~buffers['narrator'] = Buffer.read(s, ~path ++ "/samples/1600/narrator.wav"); // 1600
 ~buffers['labrador'] = Buffer.read(s, ~path ++ "/samples/text/labrador.wav"); // 1600
 ~buffers['grieg'] = Buffer.read(s, ~path ++ "/samples/1800/grieg.wav"); // 1800

~buffers['radio']['stockhausen'] = Buffer.read(s, ~path ++ "/samples/radio/stockhausen.wav"); // radio 70's (or everywhere)
~buffers['radio']['40s'] = Buffer.read(s, ~path ++ "/samples/radio/40s.wav"); // radio 40's (or everywhere)
~buffers['annebrown']['piano'] = Buffer.read(s, ~path ++ "/samples/anne brown/only piano.wav"); // 40's
~buffers['annebrown']['vocals'] = Buffer.read(s, ~path ++ "/samples/anne brown/only vocals.wav"); // 40's

~buffers['radio']['sunra'] = Buffer.read(s, ~path ++ "/samples/radio/sunra.wav"); // radio 70's (or everywhere)
~buffers['radio']['noise'] = Buffer.read(s, ~path ++ "/samples/radio/noise.wav"); // radio 70's (or everywhere)
~buffers['radio']['tunning'] = Buffer.read(s, ~path ++ "/samples/radio/tunning.wav"); // radio 70's (or everywhere)
~buffers['sunra']['wind'] = Buffer.read(s, ~path ++ "/samples/sun ra/07 the wind speaks.wav"); // radio ?? where ??

 ~buffers['sunra']['cosmos'] = Buffer.read(s, ~path ++ "/samples/sun ra/11 the design - cosmos II.wav"); // ???
~buffers['sunra']['atlantis'] = Buffer.read(s, ~path ++ "/samples/sun ra/atlantis.wav"); // ???

~buffers['sunra']['drums'] = Buffer.read(s, ~path ++ "/samples/sun ra/drums1.wav"); // office (everywhere)
~buffers['sunra']['other'] = Buffer.read(s, ~path ++ "/samples/sun ra/other.wav"); // office
~buffers['sunra']['synth1'] = Buffer.read(s, ~path ++ "/samples/sun ra/synth1.wav"); // office
~buffers['sunra']['synth2'] = Buffer.read(s, ~path ++ "/samples/sun ra/synth2.wav"); // office
~buffers['sunra']['vocals1'] = Buffer.read(s, ~path ++ "/samples/sun ra/vocals1.wav"); // offie
~buffers['sunra']['vocals2'] = Buffer.read(s, ~path ++ "/samples/sun ra/vocals2.wav"); // office
~buffers['prison'] = Buffer.read(s, ~path ++ "/samples/prison chants/im in the bottom.wav"); // water / maintenance?
~buffers['plantasia']['bass'] = Buffer.read(s, ~path ++ "/samples/spider plant/bass0.wav"); // 70's
~buffers['plantasia']['other'] = Buffer.read(s, ~path ++ "/samples/spider plant/other.wav"); // 70's
~buffers['plantasia']['synth1'] = Buffer.read(s, ~path ++ "/samples/spider plant/synth1.wav"); // 70's
~buffers['plantasia']['synth2'] = Buffer.read(s, ~path ++ "/samples/spider plant/synth2.wav"); // 70's
~buffers['building']['water1'] = Buffer.read(s, ~path ++ "/samples/building/water1.wav"); // building
~buffers['building']['water2'] = Buffer.read(s, ~path ++ "/samples/building/water2.wav"); // building
~buffers['building']['water3'] = Buffer.read(s, ~path ++ "/samples/building/water3.wav"); // building
~buffers['building']['water4'] = Buffer.read(s, ~path ++ "/samples/building/water4.wav"); // building
~buffers['building']['stream'] = Buffer.read(s, ~path ++ "/samples/building/stream.wav"); // building
~buffers['building']['rocks'] = Buffer.read(s, ~path ++ "/samples/building/rocks.wav"); // building
~buffers['building']['wood'] = Buffer.read(s, ~path ++ "/samples/building/wood.wav"); // building
~buffers['office']['original'] = Buffer.read(s, ~path ++ "/samples/office/original.wav"); // office
~buffers['office']['accomp'] = Buffer.read(s, ~path ++ "/samples/office/accomp.wav"); // office
~buffers['office']['vocals'] = Buffer.read(s, ~path ++ "/samples/office/vocals.wav"); // office

~buffers['bubbles'] = Buffer.read(s, ~path ++ "/samples/bubbles/bubbles.wav");

~synths = ();
~busfx1 = Bus.audio(s, 2);
~busfxLead = Bus.audio(s, 2);
~busVoice = Bus.audio(s, 2);
p = PZ_machine(s);
p.ignite;
x = {arg buf, out=0, amp=1, trig=1, pos=0, st=1, rate=1; Synth(\sampleNarcodeStrPZ, [\buf, buf, \amp, amp, \out, out, \trig, trig, \pos, pos, \st, st, \rate, rate])};
};


// synth func
/*~
sampler = {arg buf, out=0, amp=1, trig=1, pos=0; Synth(\sampleNarcodeStrP, [\buf, buf, \amp, amp, \out, out, \trig, trig, \pos, pos])};
~sampler.(~buffers['plantasia']['other'], 0, 1);

s.freeAll;





/// manual
x = Synth(\sampleNarcodeStrP, [\buf, ~buffers['ruth']['vocals'], \amp, 1, \out, 0, \trig, 0, \pos, 0]);
x.set(\trig, 0, \pos, 1.0.rand)
x.release;

s.sendMsg(\n_free, 18450)


// inspiration sources

BLACK FREQUENCY = room year frequency, log cutting, hoe, etc

https://www.fotomuseum.ch/en/2018/06/05/frequency/

https://www.uvic.ca/victoria-colloquium/assets/docs/Black%20to%20the%20Future.pdf

https://www.folkstreams.net/films/afro-american-work-songs-in-a-texas-prison
*/