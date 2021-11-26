function [f, A] = fft_calc(t, V)
% This function receives the Time and Amplitude arrays
% and returns the Frequency and Amplitude arrays
% [f, A] = fft_calc(t, V)
    
    N = length(V);
    Ts = t(2)-t(1);
    fs = 1/Ts;
    fN = fs/2;
    t = (0:N-1)*Ts;

    fft1 = fft(V);
    P2 = abs(fft1/N);
    A = P2(1:N/2+1);
    A(2:end-1) = 2*A(2:end-1);
    f = fs*(0:(N/2))/N;
end