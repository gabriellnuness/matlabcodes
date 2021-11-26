% This script simulates the shapes of the curves from gain equations.
% The objective is, later, integrate the theory with experimental data.

close all
clear all
clc

%% Constants input

h = 6.62607004e-34; % planck constant
c = 2.9979*10^8; % light velocity
lambda = 974.5e-9; % pump wavelength in meters
nu = c/lambda; % pump frequency

% fixed values (missing the reference citation)
% sigA = 7e-25;   % absorption cross-section of I2-I1
% sigE = 0.92*sigA; % emission cross-section of I2-I1
sigA = 7.9e-25; % from Becker (book)
sigE = 6.7e-25; % from Becker (book)
t2 = 10.8e-3; % lifetime of erbium energy level I2
Nt = 1e25;  % total erbium ion population in the laser transition 
fiber_diam = 6.12e-6; % diameter of Er doped fiber
area = pi*((fiber_diam)/2)^2;

pump_c = [100 200 300 400 500 600 650]; % mA 
pump = pump_c*0.5326 -16.64;  % characterization line in mW
% pump = pump/area;   % Intensity in mW/m^2 % too big for low gain
% considerations

Wp = linspace(pump(1),pump(end),30000); % mW based on real range from laser

%% Equation from Ball and Gleen paper (1992).
alpha0 = Nt*(Wp.*t2*sigE-sigA) ./ (Wp.*t2+1);   % small-signal gain coef
Isat = h*nu*(Wp + 1/t2 )./ (sigA + sigE); %   

I = linspace(0,5*Isat(end),length(Wp)); % Input signal to 1/2 saturation
% real input signal 

Pin = linspace(0.14e-3,5.12e-3,length(Wp));
I = Pin/area;

% i = 500 ;  %index for Wp because in real world the pumping is constant
pump_value = pump(7); % fixed value of pump mA
% i = find(Wp==pump_value);
[~, i] = min(abs(Wp-pump_value'));

alpha = alpha0(i) ./ (1 + I./Isat(i)); % optical gain coefficient

Iz = I.*alpha;
Pz = Pin.*alpha;

G = exp(alpha); % amplifier Gain -- ref[1998-Qian_Li]
G = Pz./Pin;

%% Acquire experimental data
% the easiest way to achieve this is to run the ER30, M12 and M5 code
% before running this one. Each acquisition was made with slightly
% different splice losses and other experimental differences. 
% So, run the other scripts and save the data in workspace format.
dir = 'D:\Users\Stinky\Google Drive\ITA\Data\3 - Erbium-doped fibers characterization\data';

load([dir,'\','er30data.mat'])
load([dir,'\','m12data.mat'])
load([dir,'\','m5data.mat'])

%% Plot model section
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
gratio = (1+sqrt(5))/2;
height = 7; % 7
width = gratio*height/2; % gratio*height
c = [.3 .3 .3];
belize = [41/255 128/255 185/255]; %rgb(41, 128, 185)

figure('name','Model-Pump_vs_Saturation',...
    'Units','Centimeter','Position',[35 18 width height])
plot(Wp,Isat,'color',c,'linewidth',1.5)
xlabel('Pump ($W_p$)','interpreter','latex')
ylabel('Saturation intensity ($I_{sat}$)','interpreter','latex')
grid

figure('name','Model-Pump_vs_Small-signal_Gain',...
    'Units','Centimeter','Position',[35 9  width height])
plot(Wp,alpha0,'color',c,'linewidth',1.5)
xlabel('Pump ($W_p$)','interpreter','latex')
ylabel('Small-signal gain ($\alpha_0$)','interpreter','latex')
grid

figure('name','Model-Input_intensity_vs_Gain',...
    'Units','Centimeter','Position',[35 0 width height])
plot(I*area*10^3, G,'color',c,'linewidth',1.5) % G or alpha
xlabel('Input power [mW]','interpreter','latex')
ylabel('Amplifier gain (G)','interpreter','latex')
grid
% xlim([0 5.3])
% review this part: gain coefficient(g) or amplifier gain (G)?


%% Plot experimental data
%%%%%%%%%%%%%%%%
figure('name','ER30-Pump_vs_Saturation',...
    'Units','Centimeter','Position',[22 18 width height])
plot(er30_pump,er30_Is,'Color',c)
xlabel('Pump power [mW]','interpreter','latex')
ylabel('Saturation intensity [W/m$^2$]','interpreter','latex')
grid
ylim([0 10e8])

figure('name','M12-Pump_vs_Saturation',...
    'Units','Centimeter','Position',[11 18 width height])
plot(m12_pump,m12_Is,'Color',c)
xlabel('Pump power [mW]','interpreter','latex')
ylabel('Saturation intensity [W/m$^2$]','interpreter','latex')
grid
ylim([0 10e8])

figure('name','M5-Pump_vs_Saturation',...
    'Units','Centimeter','Position',[0 18 width height])
plot(m5_pump,m5_Is,'Color',c)
xlabel('Pump power [mW]','interpreter','latex')
ylabel('Saturation intensity [W/m$^2$]','interpreter','latex')
grid
ylim([0 10e8])
%%%%%%%%%%%%%%%%
figure('name','ER30-Pump_vs_Small-signal_Gain',...
    'Units','Centimeter','Position',[22 9 width height])
plot(er30_pump,er30_alpha0,'color',c)
xlabel('Pump power [mW]','interpreter','latex')
ylabel('Small-signal gain ($\alpha_0$)','interpreter','latex')
grid

figure('name','M12-Pump_vs_Small-signal_Gain',...
    'Units','Centimeter','Position',[11 9 width height])
plot(m12_pump,m12_alpha0,'color',c)
xlabel('Pump power [mW]','interpreter','latex')
ylabel('Small-signal gain ($\alpha_0$)','interpreter','latex')
grid

figure('name','M5-Pump_vs_Small-signal_Gain',...
    'Units','Centimeter','Position',[0 9 width height])
plot(m5_pump,m5_alpha0,'color',c)
xlabel('Pump power [mW]','interpreter','latex')
ylabel('Small-signal gain ($\alpha_0$)','interpreter','latex')
grid
%%%%%%%%%%%%%%%%
figure('name','ER30-Input_intensity_vs_Gain',...
    'Units','Centimeter','Position',[22 0 width height])
for i=1:length(er30_input)
    plot(er30_input{i}*10^3,er30_gain{i}), hold on
    
    grid minor
end
xlabel('Input signal power [mW]','interpreter','latex')
ylabel('Amplifier gain (G)','interpreter','latex')
xlim([0 5.3])
legend([num2str(pump_c(1)) ' mA'],[num2str(pump_c(2)) ' mA'],...
       [num2str(pump_c(3)) ' mA'],[num2str(pump_c(4)) ' mA'],...
       [num2str(pump_c(5)) ' mA'],[num2str(pump_c(6)) ' mA'],...
       [num2str(pump_c(7)) ' mA'],'Location','northeast') 

figure('name','M12-Input_intensity_vs_Gain',...
    'Units','Centimeter','Position',[11 0 width height])
for i=1:length(m12_input)
    plot(m12_input{i}*10^3,m12_gain{i}), hold on
    grid minor
end
xlabel('Input signal power [mW]','interpreter','latex')
ylabel('Amplifier gain (G)','interpreter','latex')
xlim([0 5.3])
% legend([num2str(pump_c(1)) ' mA'],[num2str(pump_c(2)) ' mA'],...
%        [num2str(pump_c(3)) ' mA'],[num2str(pump_c(4)) ' mA'],...
%        [num2str(pump_c(5)) ' mA'],[num2str(pump_c(6)) ' mA'],...
%        [num2str(pump_c(7)) ' mA'],'Location','Best') 

figure('name','M5-Input_intensity_vs_Gain',...
    'Units','Centimeter','Position',[0 0 width height])
for i=1:length(m5_input)
    plot(m5_input{i}*10^3,m5_gain{i}), hold on
    grid minor
end
xlabel('Input signal power [mW]','interpreter','latex')
ylabel('Amplifier gain (G)','interpreter','latex')
xlim([0 5.3])
% legend([num2str(pump_c(1)) ' mA'],[num2str(pump_c(2)) ' mA'],...
%        [num2str(pump_c(3)) ' mA'],[num2str(pump_c(4)) ' mA'],...
%        [num2str(pump_c(5)) ' mA'],[num2str(pump_c(6)) ' mA'],...
%        [num2str(pump_c(7)) ' mA'],'Location','Best') 



save_open_fig('D:\Users\stinky\desktop\', [10 10], 3)