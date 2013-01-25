close all;
clear;
clc;

load('ADC_data.mat');


%call PC_ADC for first signal:
%[s_W, s_SINAD, s_SFDR, s_THD] = PC_ADC(m_Signal(:,1));




s_W = zeros(1,size(m_Signal,2));
s_SINAD = zeros(1,size(m_Signal,2));
s_SFDR = zeros(1,size(m_Signal,2));
s_THD = zeros(1,size(m_Signal,2));

for i = 1:size(m_Signal,2)
    [s_W(i), s_SINAD(i), s_SFDR(i), s_THD(i)] = PC_ADC(m_Signal(:,i));
end


figure;
plot(s_W, s_SINAD, 'r');
hold on;
plot(s_W, s_SFDR, 'g');
plot(s_W, s_THD, 'b');

legend('SINAD', 'SFDR', '-THD');
xlabel('s_w');
ylabel('dB');