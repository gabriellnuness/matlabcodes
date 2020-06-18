%% Calculation of how much different is to approximate Ir to Is in 
% interferometric mathematical model.

%% Mach-Zhender Interferometer

I0 = 10 %laser power in mW

loss = 3 %loss in dB in sensor arm in relation to the other
losslin = 10^(-loss/10)

Ir=1
Is=1*losslin

V = 2*sqrt(Ir*Is)/(Ir+Is) %Visibility variation

P=(1-V)/1*100 %percentual of variation

