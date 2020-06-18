clear all
close all
clc

t = 0:0.001:20;
A = 1;
V = 1;
phi0 = 0;
f = 10;

modulationAmp = 1.1*(pi/2);

deltaPhi = modulationAmp*sin(2*pi*f*t);
interf = A*V*cos(deltaPhi + phi0 + pi/2);

figure('Units','centimeters','position', [0 1 20 10])
plot(t,interf)
xlim([0 0.5])

