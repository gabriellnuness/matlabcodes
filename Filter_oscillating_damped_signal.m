% Create oscillating damped signal with frequency to remove with filter.

set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
clear all
close all
clc

belize = [41/255 128/255 185/255];

gamma = 70 % damping factor

fN = 2500; % Hz
tf = 0.2; % s

fs = 2*fN;
t0 = 0;
t = t0:1/fs:tf;


f0 = 700 % main sensor frequency
w0 = 2*pi*f0;
x0  = 1;

% clean signal
x = x0.*exp(-gamma/2 .* t).*exp(1i*w0.*t);
x = real(x);
decay_original = x0.*exp(-gamma/2 .* t);



% noisy signal
fnoise = 70 % Hz
A = 0.05;
x_noise = x+A*sin(2*pi*fnoise*t);


[f0_calc_clean, decay_clean] = alan_dissertation_function(x,t)
[f0_calc, decay] = alan_dissertation_function(x_noise,t)


figure('Units','centimeter','Position',[0 11 10 7],...
       'PaperPositionMode','auto')
hold on
plot(t,x,'color',[.3 .3 .3])
plot(t,decay_original,'color',belize)
legend(['decay medido=',num2str(decay_clean)],...
        ['decay original = ',num2str(gamma)])
title('original')

figure('Units','centimeter','Position',[10 11 10 7],...
       'PaperPositionMode','auto')
plot(t,x_noise,'color',[.3 .3 .3])
legend(['decay=',num2str(decay)])

hold on
gamma = decay;
decay_plot = x0.*exp(-gamma/2 .* t);
plot(t,decay_plot,'color',belize)
title('original with noise')
%% using highpass filter 

x_hp = highpass (x_noise,fnoise*2,fs);

[f0_filt, decay_filt] = alan_dissertation_function(x_hp,t)

figure('Units','centimeter','Position',[10 1 10 7],...
       'PaperPositionMode','auto')
plot(t,x_hp,'color',[.3 .3 .3])
legend(['decay=',num2str(decay_filt)])
hold on
gamma = decay_filt;
decay_plot = x0.*exp(-gamma/2 .* t);
plot(t,decay_plot,'color',belize)
title('filtered with highpass 2*f_noise')

%% using cutoff frequency filter
my_filter = designfilt('bandstopfir','FilterOrder',30, ...
         'CutoffFrequency1',60,'CutoffFrequency2',80, ...
         'SampleRate',fs);
x_myfilter = filter(my_filter, x_noise);
[f0_myfilter, decay_myfilter] = alan_dissertation_function(x_myfilter,t)

figure('Units','centimeter','Position',[0 1 10 7],...
       'PaperPositionMode','auto')
plot(t,x_myfilter,'color',[.3 .3 .3])

legend(['decay=',num2str(decay_myfilter)])
hold on
gamma = decay_myfilter;
decay_plot = x0.*exp(-gamma/2 .* t);
plot(t,decay_plot,'color',belize)
title('Cutoff filter of matlab')


%% Fitting function using matlab envelope function

% [env_up, env_down] = envelope(x_noise,30,'analytic');
[env_up, env_down] = envelope(x_noise,1,'peak');

decay_ml = fit(t',env_up','exp1');
decay_ml = -decay_ml.b*2

figure('Units','centimeter','Position',[20 10 10 7],...
       'PaperPositionMode','auto')
hold on
plot(t,x_noise,'color',[.3 .3 .3])
plot(t,env_up)

gamma = decay_ml;
decay_plot = x0.*exp(-gamma/2 .* t);
plot(t,decay_plot,'color',belize)

legend(['decay without filter=',num2str(decay_ml)])
title('Fitting the envelope')

