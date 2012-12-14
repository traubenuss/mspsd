close all;
clear all;

Wp = 2*pi*18e3;
Amax = 0.3;
Ws = 2*pi*24e3;
Amin = 60;

N = ellipord(Wp, Ws, Amax, Amin, 's');
disp(['minimum order: ', num2str(N)]);


[B,A] = ellip(N, Amax, Amin, Wp, 's');
H = tf(B,A);

figure;
bode(H);

figure;
grpdelay(B,A, 's');

figure;
pzmap(H);


%% c)

N = 4;
[B,A] = ellip(N, Amax, Amin, Wp, 's');
H = tf(B,A);

figure;
bode(H);