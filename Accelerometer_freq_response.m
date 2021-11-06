% this scripts plots the frequency response of the accelerometer to a
% sinusoidal input signal 

set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
close all
clear all
clc

f = 0:0.01:1000; 
w = 2*pi*f;

f0 = 306.25 % Hz
w0 = 2*pi*f0;
y = 1.5 % 1/s

A = 10;% [m/s^2] fixed acceleration sweeping in frequency

%analytical solution for sinusoidal input
x = A./( sqrt( (w0^2-w.^2).^2 + y^2.*w.^2) );
x1 = A./(  (w0^2-w.^2).^2 + 1i.*y^2.*w.^2) ;
acc = tf([1],[1 y w0^2]);

figure('Units','centimeter','Position',[0 1 10 7],...
       'PaperPositionMode','auto')
plot(f,x,'color',[.3 .3 .3])
set(gca,'yscale','log')
xlabel('Frequency of acceleration [Hz]','interpreter','latex')
ylabel('Displacement [m]','interpreter','latex')
l = legend(['A = ',num2str(A),'[m/s$^2$]'],'interpreter','latex');
set(gca,'fontsize',10)
set(gca,'XMinorTick','on')
set(l,'fontsize',10)


axes('position',[.535 .535 .30 .25])
box on
% figure('Units','centimeter','Position',[0 10 10 7],...
%        'PaperPositionMode','auto')
plot(f,x,'color',[.3 .3 .3])
set(gca,'yscale','log')
% xlabel('Frequency of acceleration [Hz]','interpreter','latex')
% ylabel('Displacement [m]','interpreter','latex')
set(gca,'YTick',[])
set(gca,'fontsize',8)
xlim([305 307.5])
ylim([0.0004 0.004])

%% Save figure
% 
% dir = 'D:\Users\Stinky\Google Drive\ITA\Figures'
% cd(dir)
% 
% print(gcf,'accelerometer_freq_resp_simulation.eps','-depsc')
% 

%% Log figure to define flat frequency
figure('Units','centimeter','Position',[0 1 10 7],...
       'PaperPositionMode','auto')
loglog(f,real(x1),'color',[.3 .3 .3])
set(gca,'yscale','log')
xlabel('Frequency of acceleration [Hz]','interpreter','latex')
ylabel('Displacement [m]','interpreter','latex')
l = legend(['A = ',num2str(A),'[m/s$^2$]'],'interpreter','latex',...
    'location','northwest');
set(gca,'fontsize',10)
set(gca,'XMinorTick','on')
set(l,'fontsize',10)
grid on

%% phase
figure('Units','centimeter','Position',[0 1 10 7],...
       'PaperPositionMode','auto')
loglog(f,imag(x1),'color',[.3 .3 .3])
set(gca,'yscale','log')
xlabel('Frequency of acceleration [Hz]','interpreter','latex')
ylabel('Displacement [m]','interpreter','latex')
l = legend(['A = ',num2str(A),'[m/s$^2$]'],'interpreter','latex',...
    'location','northwest');
set(gca,'fontsize',10)
set(gca,'XMinorTick','on')
set(l,'fontsize',10)
grid on

%% Bode plot

figure('Units','centimeter','Position',[0 1 10 10],...
        'PaperPositionMode','auto')
bode(acc);

set(gca,'fontsize',10)
set(gca,'XMinorTick','on')
set(l,'fontsize',10)
grid on

















