% This script involke the simulink 'gyro1sim.slx' that simulates an open
% loop optical fiber gyroscope (IFOG) with 4 options for modulating signal.
clear all
close all
clc


% Gyroscope configuration
lambda = 1550e-9;   % wavelength [m]
n = 1.43;           % refractive index
D = 15e-2;          % diameter in [m]
N = 170*12;         % number of fiber loops

% Auxiliary calculations
pd_resp = 1;        % responsitivity [A/W]
R = D/2;            % radius
L = 2*pi*R*N;       % length
c = 299792458;      % [m/s]
v = c/n;            % light velocity inside fiber core
tau = L/v           % transit time [s]
f_mod = 1/(2*tau)   % Modulation eigen frequency [Hz]

% Optical power
I0 = 1;

% Constants needed in Simulink
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ang_vel = pi/10                % angular velocity [rad/s] 

% 1-step, 
% 2-analog, 
% 3-digital, 
% 4-serrodyne
mod_signal = 4;             
op = pi/2;                  % Operation point of modulation [rad]

mod_vpi = 3.5;              % V_pi = Voltage to modulate Pi rad [V]
step_time = tau/100          % Simulation step [s]
final_time = tau*15;        % Simulation final time [s]
sf = 2*pi*L*D/(lambda*c);   % gyroscope scale factor [s]
mod_sf = pi/mod_vpi;        % optical phase modulator scale factor [rad/V]
mod_amp = (op/2)/mod_sf;    % Amplitude is half of operation point [V]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Simulink call
output = sim('gyroModulationsExampleSim');
data = output.simout.data;
time = output.simout.time;

% Output plot
figure()
    subplot(2,1,1)
        plot(time,data)
            ylim([0 1])
            ylabel('Output [V]')
    subplot(2,1,2)
        plot(time, output.mod_signal.data/pi)
            ylabel('Modulation [\pi rad]')