function [ s_W, s_SINAD, s_SFDR, s_THD] = PC_ADC( v_Signal )

X = fft(v_Signal);
%only use the first half of the spectrum (since the second half
%is equal to the first half (real valued signal)

M = length(X);

%we only need the magnitude of the spectrum
X = abs(X);



%find the maximum which corresponds to the signal:
[A,index] = max(abs(X));

%determine relative frequency of signal:
s_W = 2*pi*(index-1)/length(X);


%set signal to 0 (2 components in the spectrum)
%The remaining compoments are noise and distortion
X_NAD = X;
X_NAD(index) = 0;
X_NAD(end-index+2) = 0;


%determine RMS value of signal
A_rms = 1/M*sqrt(2*A^2);

s_SINAD = 1/sqrt(M*(M-1)) * sqrt(sum(X_NAD.^2));
s_SINAD = A_rms/s_SINAD;
s_SINAD = 20*log10(s_SINAD);


%% SFDR

s_SFDR = A/(max(X_NAD));
s_SFDR = 20*log10(s_SFDR);



%% THD

harmonicindizes = (index-1) .* (2:6);%, index .* (-2:-1:-6) +2]
harmonicindizes = mod(harmonicindizes, M);
harmonicindizes = harmonicindizes + 1;

% figure;
% stem(X_NAD, 'r');
% hold on;
% stem(harmonicindizes, X(harmonicindizes), 'g');
% ylabel('X[k]');
% xlabel('k');



s_THD =  sqrt(1/M.^2 * 2 * sum(X(harmonicindizes).^2))/A_rms;
s_THD = 20*log10(s_THD);



end

