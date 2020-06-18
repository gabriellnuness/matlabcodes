% This script is used to calculate the amplifier low gain value and the
% Saturation intensity of an Erbium doped fiber. According to the setup
% constructed at october 3rd.
clear
close all
clc
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')

% Losses for I_0
splice1 = -0.01 % loss in dB
dc1 = mag2db(0.88/0.12)/2 % percentage in the other output in db (100% - 12% = 88%)
splice2 = -0.04 %l loss in dB
wdm1 = -0.1 % insertion loss from wdm in 1550nm
spliceFiber1 = -0.13 % loss in dB from erbium fiber splice

% Losses for I_z
spliceFiber2 = -0.14
wdm2 = -0.1
splice3 = -0.06
splice4 = -0.01
dc2  = mag2db(100/11.5)/2 % 100% represented in db

% Erbium doped fiber specs
z = 36*0.0254 - 2e-2 % (36in - 2cm) of fiber M12 in meters

current = 491.3e-3 % [A]

% measured values in laboratory
P0_meas = [0.7263;0.7208;0.6969;0.6439;0.5763;0.4258]*10^-3 %measured in [W]
Pz_meas = [2.35;2.33;2.29;2.19;2.04;1.69]*10^-3 %measured in [W]

%I_0 measured X injected into amplifier
P0_input = P0_meas *10^(( dc1 + splice2 + wdm1 + spliceFiber1) / 10) 
Pz_output = Pz_meas *10^((-spliceFiber2 -wdm2 -splice3 -splice4 +dc2) /10)

A = pi*((5e-6)/2)^2 % m^2
I0 = P0_input/A
Iz = Pz_output/A


x = Iz-I0
y = log(Iz./I0)

plot(x,y,'k--')
hold on
P = polyfit(x,y,1)
yfit = P(1)*x + P(2)
plot(x,yfit,'k')
grid
Is = (-1/P(1))  % in W/m^2
alpha0 = P(2)/z % m^-1
legend(['$I_s$ =' num2str(Is,'%10.3e') '[$W/m^2$]'],['$\alpha_0$ =' num2str(alpha0) '[$m^{-1}$]'])



