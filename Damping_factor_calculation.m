% This script takes a mass-spring-damper system signal saved with the oscilloscope and calculates the resonance frequency and damping factor.
% Since the signal is real and contains various kinds of noise, multiple attempts of filtering are made in this script.
% The frequency fitted by an FFT and the peaks are selected by the prominence algorithm from MATLAB to avoid bias.

clear all
close all
clc

% Constants
selpath = 'D:\Users\Stinky\Google Drive\ITA\Data\9 - Accelerometer\2021.05.25'
print_number = 8; % file
peak_prec = 50;
points_after_max = 0; 
cut_freq = 300; % usually a good cut frequency is near the signal of interest or
                % double the frequency of the noise.

c = [0.3, 0.3, 0.3]; % color of the plots

% File and path selection
initial_path = pwd; 
cd(selpath)
files = dir('*.csv');
files = struct2table(files);
files = files(:,1);
files = table2array(files);
path = [selpath,'\'];
i = print_number + 1
filename = files{i};

% Importing file
wave{i} = readmatrix(filename);
wave{i} = wave{i}(3:end,:); % Particularity of file chosen - adjust if collected by other instrument
[~,col]=size(wave{i});

% Return to initial path
cd(initial_path) 

% Defining variables
time{i} = wave{i}(:,1);
time{i} = time{i}-time{i}(1);
v1{i} = wave{i}(:,2);   
v1{i} = fillmissing(v1{i},'next'); % for NaN in vector
V = v1{i};
tt = time{i};

% Start point to the analysis
% It is the maximum value of an impulse like response
[~,sp] = max(V);
sp = sp + points_after_max;
Vsp = V(sp:end);
tsp = tt(sp:end);

[f,P1] = fft_calc(tt, V);

%% Plotting original data with FFT
figure('Units','centimeter','Position',[0 19 10 7],...
       'PaperPositionMode','auto')
       subplot(2,1,1)
              plot(time{i}, v1{i})
                     ylim([0 11])
                     grid on
                     title('Original data')
       subplot(2,1,2)
              plot(f,P1);
                     set(gca,'YScale','log')
                     xlim([-50 inf])
                     grid on
                     grid minor

%% Plotting cropped data with FFT
[f,P1] = fft_calc(tsp, Vsp);
figure('Units','centimeter','Position',[10 19 10 7],...
       'PaperPositionMode','auto')
       subplot(2,1,1)
              plot(tsp, Vsp)
                     ylim([0 11])
                     grid on
                     title('Cropped data')
       subplot(2,1,2)
              plot(f,P1) ;
                     set(gca,'YScale','log')
                     xlim([-50 inf])
                     grid on
                     grid minor

%% Plotting highpass filtered data with FFT
Ts = tsp(2)-tsp(1);
fs = 1/Ts; % sample frequency of tsp
V_hp = highpass(V,cut_freq,fs);

[f, P1] = fft_calc(tt, V_hp);
figure('Units','centimeter','Position',[20 19 10 7],...
       'PaperPositionMode','auto')
       subplot(2,1,1)
              plot(tt,V_hp)
       subplot(2,1,2)
              plot(f,P1)
                     set(gca,'YScale','log')
                     grid on

%% Plotting highpass filtered data with Envelope
V = V_hp;
t = tt;
[env_up, env_down] = envelope(V,peak_prec,'peak'); % envelope(x_noise,30,'analytic');

% fitting exponential function to the envelope
func = @(a,c,gamma,x) c + a*exp((-gamma/2) * x);
fitting = fit(t,env_up,func,'StartPoint',[1 1 20]);
decay_ml = fitting.gamma

figure('Units','centimeter','Position',[20 9 10 7],...
       'PaperPositionMode','auto')
       hold on
       plot(t,V,'color',[.3 .3 .3])
              title('Filtered data with envelope method')
       plot(t,env_up)
       plot(fitting)
              xlim([t(1) t(end)])
              legend(['decay without filter=',num2str(decay_ml)])

%% Plotting cropped data with Envelope
V = Vsp;
t = tsp;

[env_up, env_down] = envelope(V,peak_prec,'peak');

% fitting exp function to the envelope
func = @(a,c,gamma,x) c + a*exp((-gamma/2) * x);
fitting = fit(t,env_up,func,'StartPoint',[1 1 20]);
decay_ml = fitting.gamma

figure('Units','centimeter','Position',[10 9 10 7],...
       'PaperPositionMode','auto')
       hold on
       plot(t,V,'color',[.3 .3 .3])
              title('Cropped data with envelope method')
       plot(t,env_up)
       plot(fitting)
              xlim([t(1) t(end)])
              legend(['decay without filter=',num2str(decay_ml)])

%% Plotting filtered and cropped data with Envelope
V = V_hp(sp:end);
t = tsp;

[env_up, env_down] = envelope(V,peak_prec,'peak');

% fitting exp to the envelope
func = @(a,c,gamma,x) c + a*exp((-gamma/2) * x);
fitting = fit(t,env_up,func,'StartPoint',[1 1 20]);
decay_ml = fitting.gamma

figure('Units','centimeter','Position',[0 9 10 7],...
       'PaperPositionMode','auto')
       hold on
       plot(t,V,'color',[.3 .3 .3])
              title('Cropped and filtered data with envelope method')
       plot(t,env_up)
       plot(fitting)
              xlim([t(1) t(end)])
              legend(['decay without filter=',num2str(decay_ml)])