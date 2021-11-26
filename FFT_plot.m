function FFT_plot_prominence(t, V, c, prom)
% This function converts a time based signal to a frequency domain by doing a FFT
% With options to select most prominent peaks in frequency, to change plot color and to change y scale to log.
% 
% fft_plot(t, V, log_scale, color, prominent_peaks)
%
% V = input signal
% t = time array
% c = [0-1,0-1,0-1]

    % Constants
    prom_value = 4/100;
    belize = [41/255 128/255 185/255];
    
    % Calculating FFT spectrum with fft_calc.m
    [f, P1] = fft_calc(t,V);

    % Placing data tip in local max values
    TF = islocalmax(P1,'MinProminence', prom_value); % local max is more representative than just sorting maximum values
    
    plot(f,P1,'-','MarkerSize',10,'Color', c) ;        
    if prom == 1
        hold on
        plot(f(TF),P1(TF),'.','MarkerSize',10,'Color',belize)
            legend('FFT', ['f [Hz] = ',num2str(f(TF))])
    end
end