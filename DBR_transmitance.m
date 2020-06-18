%% This code calculates the transmitance of an DBR cavity with 2 FBG


clc
clear all

R1 = 0.9
R2 = R1

beta = 2.41
L0 = 2e-2   %separation length of the 2 FBG

phi1 = 0;
phi2 = phi1;

Transmitance = (1-R1)*(1-R2) / ( (1-sqrt(R1*R2))^2 + 4*sqrt(R1*R2) * sin(beta*L0+(phi1+phi2)/2)^2 )