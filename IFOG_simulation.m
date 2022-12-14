% This is a simulation of an interferometric optical gyroscope

clear
% close all
clc

set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
gray = [.3 .3 .3];

% Gyroscope configuration
lambda = 1550e-9;   % wavelength [m]
n = 1.43;
D = 15e-2;          % diameter in [m]
N = 170*12;         % number of fiber loops

% Angular velocity 
%   this can be any signal, this is actually my signal of interest
ang_vel = pi/10   % [rad/s] pi/10 and 0 are my simulation values

% Auxiliary calculations
R = D/2;            % radius
L = 2*pi*R*N;       % length
c = 299792458;      % [m/s]
v = c/n;            % light velocity inside fiber core
tau = L/v;          % transit time [s]
t = linspace(0,12*tau,1000); 
f_gyro = 1/tau;

% Generic phase
phi = -2*pi:0.001:2*pi;

% Sagnac phase signal
phi_sagnac = 2*pi*L*D*ang_vel/(lambda*c) % [rad]
I0 = 1;
 
% Modulation parameters
op = pi/1.5;             % operation point (absolute value) pi/2
M = (op)/2;              % amplitude of modulation
                         % best SNR is 3*pi/4 <M< 7*pi/8
f_mod = f_gyro/2;       % modulation frequency

%% Modulations
% reciprocal modulation
% Analog sinusoidal modulation signal
phi_mod_1 = M*sin(2*pi*f_mod*t);
phi_mod_2 = M*sin(2*pi*f_mod*(t-tau));
phi_mod = phi_mod_1 - phi_mod_2;
        
% ------------------------------------------------------------------------        
% Digital modulation signal

% % Ideal
phi_mod_dig_1 = M*square(2*pi*f_mod/2*t);
phi_mod_dig_2 = M*square(2*pi*f_mod/2*(t-tau));
phi_mod_dig = phi_mod_dig_1 - phi_mod_dig_2;

% % Non-ideal
% phi_mod_dig_1 = conv(square(2*pi*f_mod*(t)), tripuls(2*pi*(4e5)*(t)));
% phi_mod_dig_1 = phi_mod_dig_1(1:floor(length(phi_mod_dig_1)/2+1));
% phi_mod_dig_1 = phi_mod_dig_1./max(phi_mod_dig_1);
% phi_mod_dig_1 = M*phi_mod_dig_1;
% 
% phi_mod_dig_2 = conv(square(2*pi*f_mod*(t-tau)), tripuls(2*pi*(4e5)*(t-tau)));
% phi_mod_dig_2 = phi_mod_dig_2(1:floor(length(phi_mod_dig_2)/2+1));
% phi_mod_dig_2 = phi_mod_dig_2./max(phi_mod_dig_2);
% phi_mod_dig_2 = M*phi_mod_dig_2;
% 
% phi_mod_dig = phi_mod_dig_1 - phi_mod_dig_2;

% ------------------------------------------------------------------------
% Fix modulation signal example
% heaviside function is a step function (x<0:0 , x=0:0.5, x>0:1)
start = 2*tau;
phi_mod_fix_1 = M*heaviside(t-start); 
phi_mod_fix_2 = M*heaviside(t-start-tau);
phi_mod_fix = phi_mod_fix_1 - phi_mod_fix_2;

% ------------------------------------------------------------------------        
% Serrodyne wave modulation signal
phi_mod_saw_1 = 2*M*sawtooth(2*pi*f_mod*t);
phi_mod_saw_2 = 2*M*sawtooth(2*pi*f_mod*(t-tau));
phi_mod_saw = phi_mod_saw_1 - phi_mod_saw_2;

% Interference intensity
I1 = (I0/2)*(1 + cos(phi_sagnac)); % without modulation
I2 = (I0/2)*(1 + cos(phi_sagnac + phi_mod)); % analog modulation
I3 = (I0/2)*(1 + cos(phi_sagnac + phi_mod_dig)); % digital modulation
I4 = (I0/2)*(1 + cos(phi_sagnac + phi_mod_fix)); % static modulation
I5 = (I0/2)*(1 + cos(phi_sagnac + phi_mod_saw)); % serrodyne modulation

%% Modulation outside proper frequency

f = 0 : f_mod*1e-3 : 6*f_mod;
tt = 1; % fixed time

% sine wave
phi_m_f   = M*sin(2*pi*f*tt);
phi_m_f_2 = M*sin(2*pi*f*(tt - tau));

% % square wave
% phi_m_f = M*square(2*pi*f/2*(tt));
% phi_m_f_2 = M*square(2*pi*f/2*(tt-tau));

D_phi_m_f = phi_m_f - phi_m_f_2;

figure
plot(f/f_mod, D_phi_m_f/M)
    xlabel('Eigen frequency (f_p)')
    ylabel('\Delta\phi/\phi_m')

%% Tiled plot design
% figures sizes for 1x3  = [5 9]
% figures sizes for 1x4  = [4 9]
size = [4 7];

% Static modulation signal
figure('Units','centimeter','Position',[0 1 size],...
         'PaperPositionMode','auto')
tlo = tiledlayout(3,1,'TileSpacing','none','Padding','none');
       
        nexttile;plot(t, phi_mod_fix_1,'color',gray)
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
        ylabel('$\phi_m(t)$ [rad]','interpreter','Latex','fontsize',10)
       
        nexttile;plot(t, phi_mod_fix_2,'color',gray)
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
        ylabel('$$\phi_m(t-\tau)$ [rad]','interpreter','Latex','fontsize',10)
        
        nexttile;plot(t, phi_mod_fix,'color',gray)
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
        ylabel('$\Delta\phi_m$ [rad]','interpreter','Latex','fontsize',10)
        xlabel('Time [s]','interpreter','Latex','fontsize',10)
set(tlo.Children,'XTick',[], 'YTick', [], 'box', 'off');

% Analog modulation signal 
figure('Units','centimeter','Position',[6 1 size],...
         'PaperPositionMode','auto')
tlo = tiledlayout(3,1,'TileSpacing','none','Padding','none');
        
        nexttile;plot(t, phi_mod_1,'color',gray)
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
%         ylabel('$\phi_m(t)$ [rad]','interpreter','Latex','fontsize',10)
        ylabel(' ','interpreter','Latex','fontsize',10)
        
        nexttile;plot(t, phi_mod_2,'color',gray)
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
%         ylabel('$$\phi_m(t-\tau)$ [rad]','interpreter','Latex','fontsize',10)
                ylabel(' ','interpreter','Latex','fontsize',10)
        
        nexttile;plot(t, phi_mod,'color',gray)
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
%         ylabel('$\Delta\phi_m$ [rad]','interpreter','Latex','fontsize',10)
        ylabel(' ','interpreter','Latex','fontsize',10)
        xlabel('Time [s]','interpreter','Latex','fontsize',10)

set(tlo.Children,'XTick',[], 'YTick', [], 'box', 'off');

% Digital modulation signal 
figure('Units','centimeter','Position',[12 1 size],...
         'PaperPositionMode','auto')
tlo = tiledlayout(3,1,'TileSpacing','none','Padding','none');
        
        nexttile;plot(t, phi_mod_dig_1,'color',gray)
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
%         ylabel('$\phi_m(t)$ [rad]','interpreter','Latex','fontsize',10)
        ylabel(' ','interpreter','Latex','fontsize',10)
        
        nexttile;plot(t, phi_mod_dig_2,'color',gray)
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
%         ylabel('$$\phi_m(t-\tau)$ [rad]','interpreter','Latex','fontsize',10)
        ylabel(' ','interpreter','Latex','fontsize',10)        

        nexttile;plot(t, phi_mod_dig,'color',gray)
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
%         ylabel('$\Delta\phi_m$ [rad]','interpreter','Latex','fontsize',10)
        ylabel(' ','interpreter','Latex','fontsize',10)
        xlabel('Time [s]','interpreter','Latex','fontsize',10)
set(tlo.Children,'XTick',[], 'YTick', [], 'box', 'off');    

% Sawtooth modulation signal 
figure('Units','centimeter','Position',[18 1 size],...
         'PaperPositionMode','auto')
tlo = tiledlayout(3,1,'TileSpacing','none','Padding','none');
        
        nexttile;plot(t, phi_mod_saw_1,'color',gray)
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
%         ylabel('$\phi_m(t)$ [rad]','interpreter','Latex','fontsize',10)
        ylabel(' ','interpreter','Latex','fontsize',10)
        
        nexttile;plot(t, phi_mod_saw_2,'color',gray)
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
%         ylabel('$$\phi_m(t-\tau)$ [rad]','interpreter','Latex','fontsize',10)
        ylabel(' ','interpreter','Latex','fontsize',10)      
        nexttile;plot(t, phi_mod_saw,'color',gray)
        xlim([0 6/f_mod]); ylim([-2.2*M 2.2*M]); 
%         ylabel('$\Delta\phi_m$ [rad]','interpreter','Latex','fontsize',10)
        ylabel(' ','interpreter','Latex','fontsize',10)
        xlabel('Time [s]','interpreter','Latex','fontsize',10)
set(tlo.Children,'XTick',[], 'YTick', [], 'box', 'off');    


%% Output interferometer signal

figure('Units','centimeter','Position',[8 12 15 12],...
         'PaperPositionMode','auto')
        
    tlo = tiledlayout(5,1,'TileSpacing','none','Padding','none');

    nexttile; 
    hold on
    colororder({'k', 'k'})
    plot(t,I4,'-')
        ylim([0 1.2]); xlim([0 t(end)])
        ylabel({'Output';'w/ static';'modulation'},...
            'interpreter','latex','fontsize',10)    
    yyaxis right
    plot(t,phi_mod_fix,'--')
        
    nexttile; 
    hold on
    plot(t,ones(1,length(t))*I1,'-')
        ylim([0 1.2]); xlim([0 t(end)])
        ylabel({'Output w/o';'modulation'},...
            'interpreter','latex','fontsize',10)

    nexttile; 
    hold on
    plot(t,I2,'-k')
        ylabel({'Output';'w/ analog';'modulation'},...
            'interpreter','latex','fontsize',10) 
    yyaxis right
    plot(t,phi_mod,'--')

    nexttile; 
    hold on
    plot(t,I3,'-k')
        ylim([0 1.2]); xlim([0 t(end)])
        ylabel({'Output';'w/ digital';'modulation'},...
            'interpreter','latex','fontsize',10)
    yyaxis right
    plot(t,phi_mod_dig,'--')
    
    nexttile; 
    hold on
    plot(t,I5,'-k')
        ylabel({'Output';'w/ Sawtooth';'modulation'},...
            'interpreter','latex','fontsize',10)
        xlabel('Time [s]','interpreter','latex','fontsize',10)  
        ylim([0 1.2]); xlim([0 t(end)])
    yyaxis right
    plot(t,phi_mod_saw,'--')
   
set(tlo.Children, 'box', 'off');    
 

%% Test operation point when rotating
lim_pos = op+phi_sagnac;
lim_neg = -op+phi_sagnac;

[num_pos,den_pos] = rat(lim_pos/pi); % modulation amplitude due to reciprocal modulation
[num_neg,den_neg] = rat(lim_neg/pi); 


Interf = (I0/2)*(1 + cos(phi));
figure('Units','centimeter','Position',[0 12 8 5],...
         'PaperPositionMode','auto')
      hold on
      % rectangle with modulation zone in Turquoise with alpha 30%
      rectangle('Position',[lim_neg -0.05 lim_pos-lim_neg 1.15],...
          'Curvature',0.1, 'FaceColor', [26/255 188/255 156/255 0.3]) 
      % Interferogram
      plot(phi,Interf,'color',gray,'linewidth',1.2)
      % Positive limit of modulation
      plot(lim_pos,(I0/2)*(1 + cos(lim_pos)),'ok')
      % Negative limit of modulation
      plot(lim_neg,(I0/2)*(1 + cos(lim_neg)),'ok')
      grid on

      set(gca,'XTick',[lim_neg,lim_pos],...
        'XTickLabel',{num2str(lim_neg,'%.2f'),...
                     num2str(lim_pos,'%.2f')})
      xlabel('Phase [rad]','interpreter','latex','fontsize',10)
      ylabel('Interferogram [V]','interpreter','latex','fontsize',10)
      Ax = gca;
      Ax.YGrid = 'on';
      Ax.Layer = 'top';
      Ax.GridAlpha = 0.1;

      
%% saving files

% cd 'D:\Users\Stinky\Google Drive\ITA\Doctorate\Projeto\Projeto FAPESP\art'
% 
% 
% saveas(figure(1),'modulation_signal_static','eps2c')
% saveas(figure(2),'modulation_signal_analog','eps2c')
% saveas(figure(3),'modulation_signal_digital','eps2c')
% saveas(figure(4),'modulation_signal_saw','eps2c')
% saveas(figure(5),['interferometer_mod_output','_phi_s_',num2str(phi_sagnac,'%.2f'),'.eps'],'eps2c')
% saveas(figure(6),['interferogram_operation_point','_phi_s_',num2str(phi_sagnac,'%.2f'),'.eps'],'eps2c')
% 
% 
% cd 'D:\Users\Stinky\Google Drive\ITA\Codes\MATLAB'

%% Plotting 2 angular velicities in one figure
% % first, run the script as usual.
% % then, without closing the figures, run this subsection
% 
% figure(4)
% nexttile(1); hold on; plot(t,ones(1,length(t))*I1,'-k','linestyle','-.')
%              legend('$\Omega=0$ rad/s','$\Omega=\pi/10$ rad/s',...
%                  'location','southeast','fontsize',10)    
% nexttile(2); hold on; plot(t,I2,'-k','linestyle','-.')
% nexttile(3); hold on; plot(t,I3,'-k','linestyle','-.')
% nexttile(4); hold on; plot(t,I4,'-k','linestyle','-.')
% 
% % cd 'D:\Users\Stinky\Google Drive\ITA\Doctorate\Projeto\Projeto FAPESP\art'
% % saveas(figure(4),'interferometer_mod_output_phi_s_0_and_0.1pi.eps','eps2c')
% % cd 'D:\Users\Stinky\Google Drive\ITA\Codes\MATLAB'
% % 
% % %%
% figure(4)
% nexttile(1); hold on; plot(t,ones(1,length(t))*I1,'b','linestyle','--')
%              legend('$\Omega=0$ rad/s','$\Omega=\pi/10$ rad/s','$\Omega=-\pi/10$ rad/s',...
%                  'location','southeast','fontsize',10)    
% nexttile(2); hold on; plot(t,I2,'b','linestyle','--')
% nexttile(3); hold on; plot(t,I3,'b','linestyle','--')
% nexttile(4); hold on; plot(t,I4,'b','linestyle','--')


%% FFT of output
figure
fft_plot(t,I2,[.3 .3 .3],0.1)

