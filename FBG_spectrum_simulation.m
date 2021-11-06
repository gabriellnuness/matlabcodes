% This script is used to predict the optical fiber Bragg grating reflection
% spectrum due to its construction characteristics. Such as, refractive
% index change, period, length...
% Based on the congress paper Prasad, et al. (2020) 
% DOI: 10.1109/RTEICT49044.2020.9315659 
% 
% and on the master's dissertation of Cazo, R. M., 2001. (ITA)
%
%
% Version: MATLAB 2019b
% Author:Gabriel Nunes

clear all
close all
clc


%% input constants

lambda_l = 257 * 10^-9; % inscribing UV laser [nm]
theta = 14.13; % [deg]
alpha = 0.14; % [deg]
n_eff = 1.45; % effective refractive index of optical fiber

% 
theta = deg2rad(theta);
alpha = deg2rad(alpha);


period = lambda_l / (2*sin(theta - 2*alpha)); % grating period [m]
% design Bragg wavelength in terms of the inscription angles
lambda_d = n_eff * lambda_l / sin(theta-2*alpha);

wave = linspace(1500e-9,1600e-9,1e5); % 1500 nm -- 1600 nm


%% FBG profile
v = 1; % visibility
dn_co = 10^-4; % DC offset of refractive index variation
phi = 0; % term related to chirpping process
z = linspace(0,10e-3,10e5); % length of FBG

% variation of refractive index in the fiber (FBG profile)
dn_eff = dn_co.*(1+v.*cos(2*pi/period.*z + phi)); 

figure
plot(z,dn_eff)
    xlim([0,10*period])
    ylim([-dn_co*0.1 dn_co*2.1])
    
%% Reflection spectrum of FBG

% input
dn_eff_mean = 1e-4; % refractive index mean variation
L = z(end); % FBG length
dphi = 0; % chirp
dz = 1;

% calculation
zeta = 2*pi* dn_eff_mean ./ wave; % auto-coupling coefficient
k = zeta/2; 

delta_d = 2*pi*n_eff.*(1./wave - 1/lambda_d);
zeta_p = delta_d + zeta - 1/2 * dphi/dz;

% reflection final equation
R = (sinh(  sqrt( (k*L).^2 - (zeta_p*L).^2)).^2)./...
    ( (-(zeta_p.^2)./ k.^2) + cosh( sqrt( (k*L).^2 -(zeta_p*L).^2 )).^2);
[Rm,ind] = max(R);
lambda_R_max = wave(ind) ;

figure
plot(wave,R)
    xlim([lambda_R_max-1e-9 lambda_R_max+1e-9 ])
    ylim([0 1])

%% Changing FBG parameters

% Changing L, the 
figure
hold on
for L = 1e-3:1e-3:10e-3
    zeta = 2*pi* dn_eff_mean ./ wave; % auto-coupling coefficient
    k = zeta/2; 
    delta_d = 2*pi*n_eff.*(1./wave - 1/lambda_d);
    zeta_p = delta_d + zeta - 1/2 * dphi/dz;
    
    R = (sinh(  sqrt( (k*L).^2 - (zeta_p*L).^2)).^2)./...
        ( (-(zeta_p.^2)./ k.^2) + cosh( sqrt( (k*L).^2 -(zeta_p*L).^2 )).^2);

    plot(wave,R, 'DisplayName',['L = ',num2str(L*1000),' mm'])
    legend('-DynamicLegend');
end
[Rm,ind] = max(R);
lambda_R_max = wave(ind) ;
xlim([lambda_R_max-1e-9 lambda_R_max+1e-9 ])
ylim([0 1])


%%
% changing refractive refractive index 
figure
hold on
L = 1e-3;
for dn_eff_mean = 1e-4:1e-4:10e-4
    zeta = 2*pi* dn_eff_mean ./ wave; % auto-coupling coefficient
    k = zeta/2; 
    delta_d = 2*pi*n_eff.*(1./wave - 1/lambda_d);
    zeta_p = delta_d + zeta - 1/2 * dphi/dz;

    R = (sinh(  sqrt( (k*L).^2 - (zeta_p*L).^2)).^2)./...
        ( (-(zeta_p.^2)./ k.^2) + cosh( sqrt( (k*L).^2 -(zeta_p*L).^2 )).^2);

    plot(wave,R, 'DisplayName',['\delta n_{eff} = ',num2str(dn_eff_mean)])
    legend('-DynamicLegend');
end
[Rm,ind] = max(R);
lambda_R_max = wave(ind) ;
xlim([lambda_R_max-3e-9 lambda_R_max+3e-9 ])
ylim([0 1])


%%
% changing the grating period
figure
hold on
L = 1e-3;
% there is an interval limitation in which the periods works.
for period = 0.52e-6: 0.005e-6 : 0.55e-6 

    lambda_d = 2*n_eff*period;
    
    zeta = 2*pi* dn_eff_mean ./ wave; % auto-coupling coefficient
    k = zeta/2; 
    delta_d = 2*pi*n_eff.*(1./wave - 1/lambda_d);
    zeta_p = delta_d + zeta - 1/2 * dphi/dz;

    R = (sinh(  sqrt( (k*L).^2 - (zeta_p*L).^2)).^2)./...
        ( (-(zeta_p.^2)./ k.^2) + cosh( sqrt( (k*L).^2 -(zeta_p*L).^2 )).^2);

    plot(wave,R, 'DisplayName',['\Lambda = ',num2str(period*10^6),'um'])
    legend('-DynamicLegend');
end
[Rm,ind] = max(R);
lambda_R_max = wave(ind) ;
% xlim([lambda_R_max-3e-9 lambda_R_max+3e-9 ])
% ylim([0 1])







