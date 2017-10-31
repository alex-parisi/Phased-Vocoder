% Read in a signal %
[sig, fs] = audioread('apba1.wav');
%[sig, fs] = audioread('threesentences.wav');

% Plug into function %
sig = changePitchLength(sig, fs, 'data.xls');

% Play audio %
soundsc(sig);