clear
clc

lambda = 1550e-9;   %desired wavelength of FBR
n = 1.5;    % optical fiber refractive index 

pitch = lambda/(2*n)    %FBG period of burning points
piShifted = pitch/2 % displacement needed to create a pi-shifted grating

fwhm = (0.1)*10^-9   % FWHM from FBG in meters
desiredCavitylength = lambda^2 /(fwhm*2*n)

lg = 1e-3 ; % physical length of FBG in meters
R1 = 0.9;    % reflectivity of the FBG
R2 = 0.5;

leff1 = lg * sqrt(R1) / (2*atanh(sqrt(R1)))    % effective length of FBG
leff2 = lg * sqrt(R2) / (2*atanh(sqrt(R2))) 

l0 = 5e-3;  % distance between the 2 FBG in meters

Leff = l0 + leff1 + leff2   % effective length of DBR laser cavity
modesDistance = lambda^2/(2*n*Leff) % distance among longitudinal modes in the cavity
 
if modesDistance > fwhm
    disp("the laser is single-mode!")
else
    disp("laser is NOT single-mode")
end
 