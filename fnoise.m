% this script is trying to fit the 1/f noise from data set.

clear
close all
clc

f = linspace(0,1e5,1e3);
a = 0.0001
b = 1;
noise = a./(f); 
% 
% noise_fun = @(a,b,c,x) a./( c + x.^(b));
% aa = 8.584e-06
% bb = 0.6018
% cc = 0.1277


figure
plot(f,noise)
grid

figure
loglog(f,noise)
grid

startp = [0,0,0];

fo = fitoptions('Method','NonlinearLeastSquares',...
               'Lower',[0,0],...
               'Upper',[Inf,max(f)],...
               'StartPoint',[1 1]);
ft = fittype('a./(x.^b)','options',fo)


[fitted_curve, gof] = fit(f,noise,ft)

coeffvals = coeffvalues(fitted_curve);

plot(f,fitted_curve(f))