% Closing the gyroscope loop without modulation signal.
% This script involke the simulink 'gyro3sim.slx'.
% The control is closed with a simple integrator block and ignores que
% modulation and the cosine curve of the Sagnac interferometer.
clear
close all
clc

% Gyroscope configuration
lambda = 1550e-9;   % wavelength [m]
n = 1.43;           % refractive index
D = 15e-2;          % diameter in [m]
N = 170*12;         % number of fiber loops times number of layers

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
ang_vel = 10;               % (1 to 16) [deg/s]       
ang_vel = ang_vel*pi/180    % angular velocity [deg/s] 
op = pi/2;                  % Operation point of modulation [rad]

mod_vpi = 3.5;              % V_pi = Voltage to modulate Pi rad [V]
step_time = tau/2           % Simulation step [s]
final_time = tau*(1e6)       % Simulation final time [s]
sf = 2*pi*L*D/(lambda*c);   % gyroscope scale factor [s]
mod_sf = pi/mod_vpi;        % optical phase modulator scale factor [rad/V]
mod_amp = (op/2)/mod_sf;    % Amplitude is half of operation point [V]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Simulink call
output = sim('gyroDigControlDemod');
data = output.simout.data;
time = output.simout.time;
phi_sagnac = output.phi_s.data;
phi_control = output.phi_c.data;

%% Output plot
figure("Units","centimeters","Position",[0 0 15 25])
    subplot(4,1,1)
        plot(time,data)
            xlim([-0.05 time(end)]); ylim([0 1.2*max(data)])
            ylabel('Output [V]')
    subplot(4,1,2)
        plot(time, output.mod_signal.data/pi)
            ylabel('Modulation [\pi rad]')
            xlim([-0.05 time(end)]);
    subplot(4,1,3)
        plot(time, phi_sagnac)
            ylabel('Sagnac [rad]')
            xlim([-0.05 time(end)]);
    subplot(4,1,4)
        plot(time,phi_control)
            ylabel('Control [rad]')
            xlim([-0.05 time(end)]);
