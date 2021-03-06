clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% b) estimating the desired filter by an FIR impulse response
% dense grid for sampling the desired filter in frequency domain
w_vec = linspace(-0.8*pi, 0.8*pi, 10000)';
delta_w = w_vec(2)-w_vec(1);

Delta = -0.008;


N = 0;

error_db = 0;
while error_db > -50
    N = N+2; % check only even filter orders
    int_delay = N/2;

    H_vec = exp(-1i*w_vec*(Delta + int_delay));
    
    n_vec = (0:N)';
    F_mat = exp(-1i*w_vec*(n_vec'));
    % in order to get real coefficients
    g = [real(F_mat); imag(F_mat)] \ [real(H_vec); imag(H_vec)];
    
    G_vec = freqz(g, 1, w_vec);
    
    diff = G_vec - H_vec;
    sq_error = diff'*diff *delta_w; % times delta_w, because we 
                                    % are estimating an integral
    error_db = 10*log10(sq_error);

end

display(['found filter order of ', num2str(N), ...
         ' leading to an error of ', num2str(error_db), 'dB'])

% Filter Plots
w_vec_full = linspace(-pi, pi, 10000)';
G_vec = freqz(g, 1, w_vec_full);
H_vec = exp(-1i*w_vec_full*(Delta + int_delay));
figure; hold on
subplot(2,1,1); grid on; hold on;
plot(w_vec_full/pi, 20*log10(abs(G_vec)));
mask = w_vec_full<=0.8*pi & w_vec_full>=-0.8*pi ;
plot(w_vec_full(mask)/pi, 20*log10(abs(G_vec(mask))), 'r');
plot(w_vec_full/pi, 20*log10(abs(H_vec)), 'k');
suptitle('Frequency Responses')
title('Magnitude')
xlabel('normalized frequency')
ylabel('Magnitude in dB')
legend('Estimated Filter', 'Estimated Filter from -0.8*pi to 0.8*pi',...
       'Desired Filter', 'Location', 'Best')

subplot(2,1,2); grid on; hold on;
plot(w_vec_full/pi, unwrap(angle(G_vec)));
plot(w_vec_full/pi, unwrap(angle(H_vec)), 'k');
plot(w_vec_full(mask)/pi, unwrap(angle(G_vec(mask))), 'r');

title('Phase')
xlabel('normalized frequency')
ylabel('Phase in rad')


figure
plot(w_vec_full/pi, 10*log10(abs(G_vec-H_vec).^2));
hold on
plot(w_vec_full(mask)/pi, 10*log10(abs(G_vec(mask)-H_vec(mask)).^2), 'r');
title('Squared Error in dB')
xlabel('normalized frequency')

%% farrow filter
N = 10;

deltas = -0.01:0.002:0.01;
g = zeros(N+1, size(deltas,2)); % in rows the coefficients, 
                                % in cols the different deltas

for cnt = 1:size(deltas,2)

    int_delay = N/2;
    H_vec = exp(-1i*w_vec*(deltas(cnt)+int_delay));
    
    n_vec = (0:N)';
    F_mat = exp(-1i*w_vec*n_vec');
    % in order to get real coefficients
    g(:,cnt) = [real(F_mat); imag(F_mat)] \ [real(H_vec); imag(H_vec)];
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% c) Plot g[3](Delta)
figure;
stem(deltas, g(3+1,:));
title('fourth coefficient over different deltas')
ylabel('value')
xlabel('delta')

% order of polynomes
P = 1;
% polynome coefficients
coeffs = zeros(N+1,P+1);
for cnt = 1:N+1
    coeffs(cnt,:) = polyfit(deltas, g(cnt,:),P);
end
coeffs = fliplr(coeffs);

% draw the polynome for g[3]
delta_vec = linspace(-0.01,0.01,1000);
delta_mat = zeros(P+1, length(delta_vec));
for cnt = 1:P+1
    delta_mat(cnt,:) = delta_vec.^(cnt-1);
end
y_values = coeffs(3+1,:)*delta_mat;

hold on
plot(delta_vec, y_values, 'k')
legend('coefficients', 'fitted polynome')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% d) Test the farrow filter for all deltas
figure; hold on;
plot_mtx = zeros(length(deltas),N+1); 
legend_str = cell(1,length(deltas));
for delta_cnt = 1:length(deltas)
    delta_vec = zeros(P+1,1);
    for cnt = 1:P+1
        delta_vec(cnt) = deltas(delta_cnt).^(cnt-1);
    end
    
    % impulse response with farrow filter
    h = coeffs*delta_vec;

    % absolute error of the different impulse responses
    plot_mtx(delta_cnt,:) = abs(h-g(:,delta_cnt));
    
    legend_str{delta_cnt} = ['Error for delta = ', ...
                              num2str(deltas(delta_cnt))];
    
end

stem(0:N,plot_mtx)
legend(legend_str)
title('Absolute errors of the impulse responses')
xlabel('n')
ylabel('Absolute Error Value')
