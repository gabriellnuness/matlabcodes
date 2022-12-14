% Script to simulate the effect of the angle random walk in the calculated
% atitude of the vehicle.
clear; close all; clc

% Input data
arw = 6e-4;        % deg/sqrt(h)
fs = 5;            % cut-off frequency 
filter = 1;        % Filter factor
t_final = 3600;    % seconds
time = 0:1/fs:t_final;

% Calculate the RMS value of the noise
x = arw*60;        % deg/h/sqrt(Hz)
x = x*sqrt(fs);    % deg/h
x = x*filter;      % leakage from cutoff filter

f1 = figure(1); hold on; xlim([0 t_final])
    ylabel('deg/h'); title('Angular velocity');
f2 = figure(2); hold on; ylabel('deg'); xlabel('Time [s]'); 
    tit = sprintf('Atitude during %.0f s',t_final);
    title(tit); xlim([0 t_final]);

belize = [41/255 128/255 185/255]; % color definition 

N = 1000;
buffer_atit = zeros(N,1);
for i = 1:N
    signal = x*randn(length(time),1);

    atitude = cumtrapz(signal/3600)/fs;
    
    buffer_atit(i) = atitude(end);

    set(0, 'CurrentFigure', f1); % command to avoid showing figures
    plot(time, signal,'color',[belize .1])
    set(0, 'CurrentFigure', f2);
    plot(time, atitude,'color',[belize .1])
end

figure(1)
figure(2)
leg = sprintf('Standard deviation at final position = %.2s deg',std(buffer_atit));
legend(leg,'location','best')