% This script simulate the mass-spring with damping accelerometer for the
% optical fiber accelerometer.
%   |----|   |----|
%   |----| M |----|
%   |----|   |----|

clear
close all
clc

%  Optical fiber accelerometer constants
Y = 7e10; % Young modulus [n/m^2]
L = 4.5e-2; % length [m]
D = 125e-6; % diameter [m]
A = pi*(D/2)^2; % area [m^2]

m = 20.23e-3 ; % mass [kg]
y = 1.521; % damping factor from Antune, 2009. [1/s]

% Calculations
k = Y*A/L; % spring stiffness [kg/s^2]
k = 4*k; % equivalent spring for 4 optical fibers 
w0 = sqrt(k/m) ; % [Hz]
b = y*m; % damping coefficient [kg/s] 

% Transfer functions
accel = tf( [1], [1 y k/m])
ramp = tf([1], [1 0])

% Responses
inp_impulse = impulse(accel);
inp_step = step(accel);
inp_ramp = step(series(ramp,accel));

figure
	plot(inp_impulse)
	title('impulse')
figure
	plot(inp_step)
	title('step')
figure
	plot(inp_ramp)
	title('ramp')

%% acquiring damping factor and resonance frequency from output

% Using Alan's script
[fs,as] = alan_dissertation_function(inp_impulse,inp_impulse)