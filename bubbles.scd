// bubbles:



Ndef(\b, {PlayBuf.ar(2, ~buffers['bubbles'], 1, loop: 2)}).play(0,1);

//  buf, out=0, amp=1, trig=1, pos=0, st=1, rate=1

t.tempo_(20/60)
p.ignite;

p.dict['b1'] = { PZ_layer(x, ~buffers['bubbles'], 0, 0.5, 1, {0.05.rrand(1.0)}, {3.rrand(10)}, 1).rhythm(1,1,0,0) };
p.dict['b1'] = { PZ_layer(x, ~buffers['bubbles'], 1, 0.5, 1, {0.05.rrand(1.0)}, {3.rrand(1)}, 1).rhythm(1,0,0,0) };
p.dict['b2'] = { PZ_layer(x, ~buffers['bubbles'], 2, 0.5, 1, {0.05.rrand(1.0)}, {3.rrand(6)}, 1).rhythm(0,0,0,1) };
p.dict['b3'] = { PZ_layer(x, ~buffers['bubbles'], 3, 0.5, 1, {0.05.rrand(1.0)}, {3.rrand(8)}, 1).rhythm(0,1,0,0) };
p.dict['b4'] = { PZ_layer(x, ~buffers['bubbles'], 4, 0.5, 1, {0.05.rrand(1.0)}, {3.rrand(1)}, 0.1).rhythm(0,0,2,0) };
p.dict['b5'] = { PZ_layer(x, ~buffers['building']['water2'], 0, 0.5, 1, {0.05.rrand(1.0)}, {13.rrand(6.5)}, 1).rhythm(0,1,0,0) };

s.prepareForRecord(numChannels: 6);
s.record
s.stopRecording;