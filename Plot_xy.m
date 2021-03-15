% This program collects all the spectrum data in the folder in one 3D array
% and plots all the spectrums.
clear all
close all
clc
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
dir = uigetdir();
addpath(dir)

x = xlsread('DataFile#49.xlsx','u2:u20')
y = xlsread('DataFile#49.xlsx','w2:w20')

% x = data(:,1); 
% y = data(:,2);

xlab = 'Frequ\^encia [MHz]';
ylab = 'Imped\^ancia [$\Omega$]';

gr=(1+sqrt(5))/2;
w=7;
size = [w*gr w];

figure('Units','centimeter','Position',[10 10 size],...
    'PaperPositionMode','auto')
plot(x,y,'color',[0.3 0.3 0.3])
xlabel(xlab,'interpreter','latex','FontSize',12)
ylabel(ylab,'interpreter','latex','FontSize',12)
grid
set(gcf,'renderer','painters') % vectorized
%         set(gcf,'renderer','opengl')  % rasterized figure for dense data

% saveas(gcf, 'out.eps', 'epsc2');  % save data in vectorized form
% saveas(gcf, 'out.svg', 'svg');  % vectorized form (open in browser)
% saveas(gcf, 'out.emf', 'emf'); % only vector format compatible with Word