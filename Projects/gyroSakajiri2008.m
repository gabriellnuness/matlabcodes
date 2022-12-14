% Implementation of Sakajiri, 2008 demodulation technique.
% This script involke the simulink 'gyro2sim.slx' that simulates an open
% loop optical fiber gyroscope (IFOG) with a square wave modualtion.
% The demodulation method assumes the perfect 50:50 in the directional coupler.
clear
close all
clc

% Simulation rate mutiplier (*2 is equivalent to Nyquist of the simulation)
sim_multipl = 40; 

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

rea_tau = L/v;      % real calculated value of the transit time [s]
tau = sim_multipl;  % Tau used in simulation so the minimum period used in the entire
                    % simulation is equal 1 second.
tau = 5e-6
f_mod = 1/(2*tau);  % Modulation eigen frequency [Hz]

% Optical power
I0 = 1;

% Constants needed in Simulink
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ang_vel_deg = 20;               % (1 to 16) [deg/s] % 45 seems to be the maximum value          
ang_vel = ang_vel_deg*pi/180;   % angular velocity [deg/s]
op = pi/2;                      % Operation point of modulation [rad]
mod_vpi = 3.5;                  % V_pi = Voltage to modulate Pi rad [V]
sf = 2*pi*L*D/(lambda*c);       % gyroscope scale factor [s]
mod_sf = pi/mod_vpi;            % optical phase modulator scale factor [rad/V]
mod_amp = (op/2)/mod_sf;        % Amplitude is half of operation point [V]

% Simulation constants
step_time = tau/40;     % Simulation step [s]
final_time = tau*1e4;   % Simulation final time [s]
Fs = 100;               % Chosen sample rate of the gyro [Hz]
decimation_value = ceil(1/step_time/Fs);
gyro_sample_time = step_time*decimation_value; % Actual sample rate [Hz]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Square wave modulation
mod_freq = 1/(4*tau);       % check Sakajiri, 2008.
mod_period = 1/mod_freq;
Ts = mod_period/8;          % One period divided by 8


% Display frequencies and periods used in simulation
fprintf('\ntau = %.2d s\n',tau)
fprintf('Simulation frequency = %.2d Hz\n', 1/step_time)
fprintf('IFOG Eigen frequency = %.2d Hz\n', f_mod)
fprintf('\nModulation frequency = %.2d Hz\n', mod_freq)
fprintf('Demodulation rate = %.2d Hz\n', 1/Ts)
fprintf('Angular velocity = %.3f rad/s or %.2f deg/s\n', ang_vel,ang_vel_deg)
fprintf('\nFinal time = %.4f s\n', final_time)
fprintf('Total simulation data = %.2s elements\n', final_time/step_time)
fprintf('Acquisition frequency = %.2s Hz\n', 1/(step_time*decimation_value))
fprintf('Data points after decimation = %.2e elements\n', final_time/(step_time*decimation_value))
fprintf('Estimated simulation time = %.2f min\n', final_time/step_time*1e-5/60)
%%
% Simulink call
output = sim('gyroSakajiri2008Sim');
data = output.simout.data;
time = output.simout.time;

% Data processing
I1 = data(time == Ts + 2*mod_period);
I2 = data(time == 3*Ts + 2*mod_period);
I3 = data(time == 5*Ts + 2*mod_period);
I4 = data(time == 7*Ts + 2*mod_period);


phi_s_2 = acos(2*I2-1)/2;  % it only worked when /2.
phi_s_13 = asin((I3-I1)/(I3+I1))/2;
perc_error_2 = (phi_s_2-ang_vel)/ang_vel*100;
perc_error_13 = (phi_s_13-ang_vel)/ang_vel*100;


% Output plot
figure("Units","centimeters","Position",[0 1 20 20])
    subplot(3,1,1)
        plot(time, output.mod_signal.data/pi)
            ylabel('Modulation [\pi rad]')
            ylim([-pi/4 pi/4])
    subplot(3,1,2)
        plot(time,data)
            ylim([-0.2 1.2])
            ylabel('Output [V]')
    subplot(3,1,3)
        hold on
        plot(output.sagnac1.time,output.sagnac1.data)
        plot(output.sagnac2.time,output.sagnac2.data)
            ylabel({'Demodulated ';'Sagnac phase [rad/s]'})

 

