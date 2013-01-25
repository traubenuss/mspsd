close all;
clear;
clc;


n = 1:4096;
x = 4*sin(n*2*pi/16) + 0.25*sin(n*2*pi/8) + 0.25*sin(n*2*pi/4);

X = fft(x);


stem(abs(X));


[s_W, s_SINAD, s_SFDR, s_THD] = PC_ADC(x);

s_W = s_W / pi;