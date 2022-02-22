% This script is used to generate the interference pattern of two-beam interferometers.
% The final figure is a 2D representation of the real world pattern Haidinger fringes or Fizeau fringes.

% The calculations are made considering N punctual light sources representing a laser beam with a chosen waist value. Each light source is going to be represented by a cosine function.

% Setup:
% M2    M1      Laser   Wall  
% |     |       |       | 
% |     |       |       |
% |     |       |       |

% Inputs: 
% 
% - Angle mirror 1
% - Angle mirror 2
% - Distance between mirrors (Delta_phi)
% - Distance between Laser and first mirror

% Defining variables
c = 3e8;
lambda = 532.8e-9; % wavelength of light source
nu = c/lambda;
k = 2*pi/lambda;

yS = 0; % y location of the punctual light source
dM1 = 1; % absolute z position of M2
dM2 = 2; % absolute z position of M2
dW = 4; % absolute z position of the wall
z = linspace(0,dW,1000); % z vector

d = dW;
S = cos(2*pi*c/lambda - d); % laser

S1 = cos(2*pi*c/lambda-(dW-dM1))
S2 = cos(2*pi*c/lambda-(dW-dM2))

I = (S1+S2)/2;
close all
plot(I,'.')















