% This script simulate the mass-spring with damping accelerometer for the
% optical fiber accelerometer.
%   |----|   |----|
%   |----| M |----|
%   |----|   |----|

clear
close all
clc

%  Optical fiber accelerometer constants
Y = 7*10^10; % Young modulus [n/m^2]
L = 4.5*10^-2; % length [m]
D = 125*10^-6; % diameter [m]
A = pi*(D/2)^2; % area [m^2]

m = 20.23*10^-3 ; % mass [kg]
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
[fs,as] = parametros(inp_impulse,inp_impulse)




function [fs,as] = parametros(vs,t)
% Function from Alan's dissertation entitled:
% INTERFEROMETRO OPTICO EM MALHA FECHADA COM DUAS POLARIZACOES PARA APLICACOES ESPACIAIS (2019), ITA.
%
% The function takes the frequency and the exponential decay of an impulse response signal of a damped accelerometer.

	vs=vs-mean(vs);
	%dominiodafrequencia
	vf=abs(2*fft(vs)/length(vs));%amplitudes
	f=(0:length(vs)-1)./(max(t)-min(t));%frequencias
	vf=vf(1:round(length(vs)/2));
	f=f(1:round(length(vs)/2));
	%frequenciadepico
	[~,p]=max(vf);
	%encontrar minimos laterais(limites para calculo da media)
	p1=p(1);
	p2=p(1);
	aux=0.5*max(vf);
	while vf(p1)>aux&&p1>1%lado esquerdo
		p1=p1-1;
	end

	while vf(p2)>aux&&p2<length(f)%lado direito
		p2=p2+1;
	end
	%encontrar frequencia central
	fs=trapz(f(p1:p2),f(p1:p2).*vf(p1:p2))/trapz(f(p1:p2),vf(p1:p2));
	%valores de pico
	[~,p1]=findpeaks(vs,'MinPeakHeight',0);
	[~,p2]=findpeaks(-vs,'MinPeakHeight',0);
	while length(p1)>length(p2)
		p1=p1(1:end-1);
	end
	while length(p1)<length(p2)
		p2=p2(1:end-1);
	end
	vpp=vs(p1)-vs(p2);
	tpp=t(p1);
	%identificar decaimento
	pol=polyfit(tpp,log(vpp),1);
	as=real(pol(1));
end