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
bode(H)
[mag, phase, omega] = bode(H);
mag = mag(:);
phase = phase(:);


figure;
%grpdelay(B,A, 's');

% forward differences for derivation of the phase: dphi/dw
% phase: degree, w: rad/sec -> pi/180*degree/(rad/sec) = sec
group_delay = zeros(size(phase,1), 1);
group_delay(2:end) = -pi/180*(phase(1:end-1)-phase(2:end))./(omega(1:end-1)-omega(2:end));
group_delay(1) = group_delay(2);
semilogx(omega, group_delay)
grid on
ylabel('Group Delay (sec)')
xlabel('Frequency (rad/sec)')
title('Group Delay')


figure;
pzmap(H);


%% c)

N = 4;
[B,A] = ellip(N, Amax, Amin, Wp, 's');
H = tf(B,A);

figure;
bode(H);