% plotting electric field 

clear all
close all
%E_0+ = E1
%E_0- = E2
E1 = 1;
E2 = 1;
lambda = 1;
B = 2*pi/lambda;
z = -lambda:0.00001:lambda;

E = sqrt(E1^2 + E2^2 + 2*E1*E2*cos(2*B.*z)).*exp(-1i.*atan( ((E1-E2)/(E1+E2)).*tan(B.*z) ));
E_amp = sqrt(E1^2 + E2^2 + 2*E1*E2*cos(2*B.*z));

figure
plot(z,E)

figure
plot(z,E_amp)

% Reflection coef  is equivalent to the visibility of the interferometer

figure
hold on
for i = 0:0.2:1
    E2 = i;
%     E = sqrt(E1^2 + E2^2 + 2*E1*E2*cos(2*B.*z)).*exp(-1i.*atan( ((E1-E2)/(E1+E2)).*tan(B.*z) ));
    E_amp = sqrt(E1^2 + E2^2 + 2*E1*E2*cos(2*B.*z));
    plot(z,E_amp)    
end
