% Michelson interferometer simulated with fast Fourier transform
clear all
close all

% Definitions
Np = 10001 %5001; % number of points to numeric calculation
lambda = 532.8e-9; % light source wavelength



d = 0.15; % propagation distance before the closest mirror
dz = 0*lambda %(100000)*lambda; % lambda/8; % Distance difference between mirrors M1 and M2

L = sqrt((Np-1)*lambda*d) ; % Correction to make dx = dx0

dx0 = L/(Np-1); % Np eh numero de pontos, intervalos = N-1
fc=-0.1; % foco lente

z1 = d; % distance between BS and M1
z2 = z1+dz; % distance between BS and M2

% !! vectorize this for loop later
for i=1:Np
  x0(i)=-L/2+(i-1)*dx0;
  u0(i)=exp(-x0(i)^2/1e-6);
  fz1(i)=1/sqrt(Np-1)*exp(1i*2*pi/lambda*(z1+x0(i)^2/(2*z1)));
  fz2(i)=1/sqrt(Np-1)*exp(1i*2*pi/lambda*(z2+x0(i)^2/(2*z2)));  
  lente(i)=exp(-1i*pi*x0(i)^2/(lambda*fc));
end

% *************
% Laser beam
% *************

% lente divergente
u = u0.*lente;
% Propagacao ate divisor de feixes 
u = conv(u,fz1,"same");

% *************
% Beam 1
% *************

% Propagacao ate espelho 1
u1 = sqrt(2)/2*conv(u,fz1,"same");
% Propagacao espelho 1 ate divisor de feixes
u1 = conv(u1,fz1,"same");
% Propagacao divisor de feixes ate detetor
u1 = conv(u1,fz1,"same");

% *************
% Beam 2
% *************

% Propagacao ate espelho 2
u2 = sqrt(2)/2*conv(u,fz2,"same");
% Propagacao espelho 2 ate divisor de feixes
u2 = conv(u2,fz2,"same");
% Propagacao divisor de feixes ate detetor
u2 = conv(u2,fz1,"same");

% Combinacao dos feixes no detetor
ur = u1+u2;
I = abs(ur).^2.;

%
figure('Position',[80,80,600,450]);

subplot(211)
plot(x0,u0)
% axis([-L/2,L/2,-0.2,1.1]);
title('Electric field')

subplot(212)
plot(x0,I)
title('Intensity')
