% This script is adapted from Luiz Henrique thesis "High gain approach 
% and sliding mode control applied to quadrature interferometer" (2019).
%
% It is used to correct the quadrature condition of sinusoidal signals,
% in this way there is no need to perfectly align the Michelson
% interferometer to equalize the signals.


set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
clear
close all
clc

%% Ellipse Fitting Simulation and Quadrature correction algorithm

A1V1 = 1;           % Cossine function amplitude;
A2V2 = 3;           % Sine function amplitude;
B = 5;              % Amplitude of the phase displacement signal
r = A1V1/A2V2;      % ratio between the amplitudes A1V1 and A2V2
A1 = 2;             % offset of v_m1
A2 = 2.5;           % offset of v_m2
alpha = pi/6;       % Quadrature phase error
w = 3*pi/4;         % Angular frequency of the phase displacement signal
wt = 0:0.001:6*pi;  % Total range of phase displacement signal
t = wt/w;           % time vector
phi = B*sin(wt);    % phase displacement signal

%% Ideal quadrature signals
v_id1 = A1V1*cos(phi);
v_id2 = A1V1*sin(phi);

%% Distorted quadrature signals (with noise)
noise1 = random('norm',0,0.05,[1 length(wt)]);
noise2 = random('norm',0,0.05,[1 length(wt)]);

v_m1 = v_id1 + A1 + noise1;
v_m2 = (1/r)*(v_id2*cos(alpha)+v_id1*sin(alpha)) + A2 + noise2;

% Matrix of the sampled data
X = [(v_m1').^2, (v_m2').^2, v_m1'.*v_m2', v_m1', v_m2'];

% Y matrix
Y = ones(length(t),1);

% Matrix of the coefficients Q = [A; B; C; D; E];
Q = (X'*X)\(X')*Y;

% Calculated parameters
alpha_fit   = asin( Q(3) / sqrt(4*Q(1)*Q(2)) );
r_fit       = sqrt( Q(2)/Q(1) );
A1_fit      = ( 2*Q(2)*Q(4) - Q(5)*Q(3) ) / ( (Q(3)^2) - 4*Q(1)*Q(2) );
A2_fit      = ( 2*Q(1)*Q(5) - Q(4)*Q(3) ) / ( (Q(3)^2) - 4*Q(1)*Q(2) );

%Corrected signals
v_d1 = v_m1 - A1_fit;
v_d2 = (r*(v_m2-A2_fit) - sin(alpha_fit)*(v_m1-A1_fit)) / cos(alpha_fit);

%Fitted ellipse
vd1_fit = v_id1 + A1_fit;
vd2_fit = (1/r_fit)*(v_id2*cos(alpha_fit) + v_id1*sin(alpha_fit)) + A2_fit;

% Ploting figures
figure(Units="centimeters",Position=[1 0 10 7]);
	plot(t,v_m1,t,v_m2)
		set(gca,'FontSize',12)
		xlabel('Time [s]','interpreter','latex');
		ylabel('Simulated $v_1^m$ and $v_2^m$','interpreter','latex');

figure(Units="centimeters",Position=[11 0 10 7]);
	plot(v_m1,v_m2,vd1_fit,vd2_fit)
		set(gca,'FontSize',12)
		xlabel('Time [s]','interpreter','latex');
		ylabel('Simulated $v_1^m$ and $v_2^m$' ,'interpreter','latex');
        axis equal

figure(Units="centimeters",Position=[21 0 10 7]);
	plot(v_d1,v_d2)
		set(gca,'FontSize',12)
		xlabel('$v^d_1$','interpreter','latex');
		ylabel('$v_2^d$','interpreter','latex');
        axis equal