% This script was made to calculate optical fiber laser cavity length
% according to FBG width and reflectivity to have a single-mode laser.
% R = 0.96461, fbgWidth = 0.1, 
clear all
clc

%% data input
fbgWidth = 0.259e-9;   % FBG spectrum width [m]
lambdaPeak = 1558e-9; % desired laser wavelength [m]
n = 1.5;              % Fiber refractive index
fbgL = 8e-3;          % physical size of FBG in meters
R = 0.95;              % FBG reflectivity th = 0.96461
fiberD = 5.6e-6;
alpha0 = 4;           % [m^-1]
Is = 9.1e8;           % saturation intensity [W/m^2]

%% Calculation of laser cavity length
Lcav = lambdaPeak^2 / (2*n*fbgWidth); % [m]
disp(['Cavity length in mm: ',num2str(Lcav*1000),' mm'])

%% FBG effective length 
Leff = fbgL*sqrt(R)/(2*atanh(sqrt(R)) ); %[m]
disp(['FBG effective length in mm: ',num2str(Leff*1000),' mm'])
disp(['Distance between FBGs in mm: ',num2str(Lcav*1000-2*Leff*1000),' mm'])

%% Laser threshold and intensity calculation
% data input
L = Lcav; % [m]
L = 15e-2; % defined to test
r1 = R;
r2 = R;
splice1 = 0.3;
splice2 = 0.17;
loss1 = 1/db2mag( (splice1) *2) ; % no loss = 1, 2% loss = 0.98
loss2 = 1/db2mag( (splice2) *2) ;
% Rth = exp(-2*alpha0*L)/(loss1*loss2)

% Laser treshold condition
if alpha0*L > -(1/2)*log(r1*r2*loss1*loss2)
    disp('------- Habemus laser!--------')
else
    disp('No laser :( -> Too much losses')
end

% Laser intensity calculation
IL = ((1-r2)*loss2/((1-r2*loss2)+sqrt(r2*loss2/(r1*loss1))*(1-r1*loss1)))...
      *Is*(alpha0*L + (1/2)*log(r1*r2*loss1*loss2));
A = pi*(fiberD/2)^2;
PL = IL*A;
disp(['Laser Power in mW: ',num2str(PL*1000, '%2.4f'),' mW'])














