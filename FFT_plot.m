%%  FFT function to compare frequency of input signal x output signal
% V = signal to be analyzed
% t = time array
% c = plot color in the format rbg [0-1,0-1,0-1]
function fft_plot(V,t,c)
N = length(V);
Ts = t(2)-t(1);
fs = 1/Ts;
fN = fs/2;
tt=(0:N-1)*Ts;

fft1 = fft(V);
P2 = abs(fft1/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f=fs*(0:(N/2))/N;

% figure
% plot(f,mag2db(P1)) %in decibels
% figure
plot (f,P1,'.-','MarkerSize',10,'Color',c)
xlim([-10 300])
end