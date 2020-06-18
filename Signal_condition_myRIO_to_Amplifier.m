%this script calculates values of resistors to convert myRIO output from a
%positive range of voltage only.
clc
clear


%myRIO output transfer function conversion.
prompt = 'Insert the initial value of the new range [V]:'; 
out1= input(prompt);
prompt = 'Insert the final value of the new range [V]:'; 
out2= input(prompt);

y = (out2-out1)/2
vi = [-10:0.4:10];
x= -vi(1)/y
v0 = vi./x + y;
ampi = v0(1)
ampf = v0(length(v0))
% 
% %AMP OP calculation of resistances
% vcc = 15; %V
% RF = 10; %kOhm
% v0 = -( (RF/R1)*v1 + (RF/R2)*v2);
