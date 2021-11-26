% Script to calculate the maximum amplitude in radians is acceptable to stay
% in the linear region of the cosine curve given a total harmonic distortion arbitrary value
% MATLAB r2019b
% author: Gabriel Nunes


clear all
close all
clc

% Constants
thd_lim = 3; % maximum desired THD value
t = 0:0.0001:2*pi;
Q = [0 pi/2]; 
f = 10;    % signal frequenct
w = 2*pi*f;

% Functions to plot
I = cos(t); % interferometer
line = -1*t + pi/2; % tangent line to pi/2

% Finding A for THD threshold
harmonic_dist = 0;  
A = 0; % input signal amplitude
while harmonic_dist <= thd_lim
    signal = A*sin(w*t) + pi/2; % input signal
    interf = cos(signal); % output signal
    harmonic_dist = 100*(10^(thd(interf,1/0.0001,10)/20));
    A = A + 0.001; %increment
end
signal_dist = 100*(10^(thd(signal,1/0.0001,10)/20));

fprintf('The input signal THD was: %.1f %%\n', signal_dist)
fprintf('The signal amplitude to reach a THD = %.1f %% is: %.2f [rad]\n', harmonic_dist, A)

% Error in relation to the quadrature tangent line 
xx = pi/2 - A;
int = cos(xx);
tan_line = -xx + pi/2;
error_100 = (int - tan_line)/tan_line * 100;

fprintf('The error in relation to the tangent line is: %.1f %%\n', error_100)

% Plot
figure('Units','centimeter','Position',[0 1 20 15],...
    'PaperPositionMode','auto')
    subplot(2,2,1)
        hold on
        plot(t,I)
        plot(t,line,'--')
        plot(Q(2),Q(1),'k*')
        plot(signal, t -1.2)
            ylim([-1.2 1.2])
            title('Interferogram')
            xlabel('Phase [rad]')
            ylabel('Intensity [u.a.]')
            grid
    subplot(2,2,2)
        plot(t,interf)
            ylim([-1.2 1.2])
            xlim([0 10*1/f])
            xlabel('Time [s]')
            ylabel('Intensity [u.a.]')
            title('Interferometer output')
            grid
    subplot(2,2,3)
        thd(signal,1/0.0001,10);
        xlim([0 150/1000])
        title('THD input signal')
    subplot(2,2,4)
        thd(interf,1/0.0001,10);
            xlim([0 150/1000])
            title('THD interferometer')