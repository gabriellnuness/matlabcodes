% This is a simulation of an interferometric optical gyroscope
clear, close all, clc
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')

% Gyroscope configuration
lambda = 1550e-9;   % wavelength [m]
n = 1.43;
D = 15e-2;          % diameter in [m]
N = 170*12;         % number of fiber loops

% Angular velocity 
%   this can be any signal, this is actually my signal of interest
ang_vel = 0    % [rad/s]

% Auxiliary calculations
R = D/2;            % radius
L = 2*pi*R*N;       % length
c = 299792458;      % [m/s]
v = c/n;            % light velocity inside fiber core
tau = L/v;          % transit time [s]
t = linspace(0,12*tau,1000); 

% Generic phase
phi = -2*pi:0.001:2*pi;

% Sagnac phase signal
phi_sagnac = 2*pi*L*D*ang_vel/(lambda*c) % [rad]
I0 = 1;
 
%% Modulations
% ------------------------------------------------------------------------
% Analog sinusoidal modulation signal
op = pi/2;               % operation point (absolute value)
M = (op)/2;              % amplitude of modulation
                         % best SNR is 3*pi/4 <M< 7*pi/8
f_mod = 1/(2*tau);       % modulation frequency
% reciprocal modulation
phi_mod_1 = M*sin(2*pi*f_mod*t);
phi_mod_2 = M*sin(2*pi*f_mod*(t-tau));
phi_mod = phi_mod_1 - phi_mod_2;
        
% ------------------------------------------------------------------------        
% Digital modulation signal
phi_mod_dig_1 = M*square(2*pi*f_mod/2*t);
phi_mod_dig_2 = M*square(2*pi*f_mod/2*(t-tau));
phi_mod_dig = phi_mod_dig_1 - phi_mod_dig_2;

% ------------------------------------------------------------------------
% Fix modulation signal example
    % heaviside function is a step function (x<0:0 , x=0:0.5, x>0:1)
start = 2*tau;
phi_mod_fix_1 = M*heaviside(t-start); 
phi_mod_fix_2 = M*heaviside(t-start-tau);
phi_mod_fix = phi_mod_fix_1 - phi_mod_fix_2;
             
%% Tiled plot design
close all

% Static modulation signal TILE TEST
figure('Units','centimeter','Position',[0 1 5 9],...
         'PaperPositionMode','auto')
tlo = tiledlayout(3,1,'TileSpacing','none','Padding','none');
       
        nexttile;plot(t, phi_mod_fix_1,'color',[.3 .3 .3])
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
        ylabel('$\phi_m(t)$ [rad]','interpreter','Latex','fontsize',10)
       
        nexttile;plot(t, phi_mod_fix_2,'color',[.3 .3 .3])
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
        ylabel('$$\phi_m(t-\tau)$ [rad]','interpreter','Latex','fontsize',10)
        
        nexttile;plot(t, phi_mod_fix,'color',[.3 .3 .3])
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
        ylabel('$\phi_m$ [rad]','interpreter','Latex','fontsize',10)
        xlabel('Time [s]','interpreter','Latex','fontsize',10)
set(tlo.Children,'XTick',[], 'YTick', [], 'box', 'off');

% Analog modulation signal TILE TEST
figure('Units','centimeter','Position',[8 1 5 9],...
         'PaperPositionMode','auto')
tlo = tiledlayout(3,1,'TileSpacing','none','Padding','none')
        
        nexttile;plot(t, phi_mod_1,'color',[.3 .3 .3])
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
        ylabel('$\phi_m(t)$ [rad]','interpreter','Latex','fontsize',10)
        
        nexttile;plot(t, phi_mod_2,'color',[.3 .3 .3])
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
        ylabel('$$\phi_m(t-\tau)$ [rad]','interpreter','Latex','fontsize',10)
        
        nexttile;plot(t, phi_mod,'color',[.3 .3 .3])
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
        ylabel('$\phi_m$ [rad]','interpreter','Latex','fontsize',10)
        xlabel('Time [s]','interpreter','Latex','fontsize',10)

set(tlo.Children,'XTick',[], 'YTick', [], 'box', 'off');

% Digital modulation signal TILE TEST
figure('Units','centimeter','Position',[16 1 5 9],...
         'PaperPositionMode','auto')
tlo = tiledlayout(3,1,'TileSpacing','none','Padding','none');
        
        nexttile;plot(t, phi_mod_dig_1,'color',[.3 .3 .3])
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
        ylabel('$\phi_m(t)$ [rad]','interpreter','Latex','fontsize',10)
        
        nexttile;plot(t, phi_mod_dig_2,'color',[.3 .3 .3])
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
        ylabel('$$\phi_m(t-\tau)$ [rad]','interpreter','Latex','fontsize',10)
        
        nexttile;plot(t, phi_mod_dig,'color',[.3 .3 .3])
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
        ylabel('$\phi_m$ [rad]','interpreter','Latex','fontsize',10)
        xlabel('Time [s]','interpreter','Latex','fontsize',10)
set(tlo.Children,'XTick',[], 'YTick', [], 'box', 'off');    

%% Modulation intensity inside interferometer

% Interference intensity
I1 = (I0/2)*(1 + cos(phi_sagnac)); % without modulation
I2 = (I0/2)*(1 + cos(phi_sagnac + phi_mod)); % analog modulation
I3 = (I0/2)*(1 + cos(phi_sagnac + phi_mod_dig)); % digital modulation
I4 = (I0/2)*(1 + cos(phi_sagnac + phi_mod_fix)); % static modulation

figure('Units','centimeter','Position',[8 13 15 12],...
         'PaperPositionMode','auto')
subplot(4,1,1); plot(t,I1,'.')
    title('Only Sagnac phase')
    ylim([0 1.2])
subplot(4,1,2); plot(t,I2)
    title('Sagnac phase with analog modulation')
    ylim([0 1.2])
subplot(4,1,3); plot(t,I3)
    title('Sagnac phase with digital modulation')
    ylim([0 1.2])
subplot(4,1,4); plot(t,I4)
    title('Sagnac phase with static modulation')
    ylim([0 1.2])
    
%% Interferometric curve

[num,den] = rat(2*M/pi) % modulation amplitude due to reciprocal modulation
Interf = (I0/2)*(1 + cos(phi));
figure('Units','centimeter','Position',[0 13 8 5],...
         'PaperPositionMode','auto')
      plot(phi,Interf,'color',[.3 .3 .3])
      xline(2*M)
      grid on
      set(gca,'XTick',2*M,'XTickLabel',[num2str(num),'$\pi$/', num2str(den)])
    
















