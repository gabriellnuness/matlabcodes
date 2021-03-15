% Trying to calculate how much phase-delay is acceptable to stay
% in the linear region of the cosine curve

clear all
close all
clc

t = 0:0.0001:2*pi;

I = cos(t);
line = -1*t + pi/2;
Q = [0 pi/2];





f = 10;    %freq of signal
w = 2*pi*f;
% A = pi/2;  %desired value to be found to THD = 3%


%finding A for THD threshold
harmonic_dist = 0;  
A = 0;
while harmonic_dist <= 3
    
    signal = A*sin(w*t) + pi/2;
    interf = cos(signal);

%     harmonic_dist = db2mag(thd(interf))*100;
    harmonic_dist = 100*(10^(thd(interf,1/0.0001,10)/20));
    
    A = A + 0.001; %increment
end
A
harmonic_dist
signal_dist = 100*(10^(thd(signal,1/0.0001,10)/20))


% Error calculation to tangent line
xx = pi/2 - A;
int = cos(xx);
l = -xx +pi/2;
error_100 = (int - l )/l  *100

%% plot

figure('Units','centimeter','Position',[10 0 30 25],...
    'PaperPositionMode','auto')

subplot(2,2,1)
    plot(t,I)
    hold on
    plot(t,line,'--')
    plot(Q(2),Q(1),'k*')
    plot(signal, t -1.2)
    ylim([-1.2 1.2])
    % clear line
    % x = [-A+pi/2 +A+pi/2];
    % y = [0 0];
    % line(x,y)
    grid

subplot(2,2,2)
    plot(t,interf)
    ylim([-1.2 1.2])
    xlim([0 10*1/f])
    grid

subplot(2,2,3)
    thd(signal,1/0.0001,10);
    xlim([0 150/1000])

subplot(2,2,4)
    thd(interf,1/0.0001,10);
    xlim([0 150/1000])

% 
% figure
% x = [-A+pi/2 +A+pi/2];
% y = [0 0];
% line(x,y)




