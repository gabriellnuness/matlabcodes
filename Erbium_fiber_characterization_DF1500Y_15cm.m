% This script is used to calculate the amplifier low gain value and the
% Saturation intensity of an Erbium doped fiber. According to the setup
% constructed at october 3rd.
clear all
close all
clc
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
width = 10;
height = 7.5;

% Losses for I_0
splice1 = -0.01; % loss in dB
%DC1 88%  - 12% first measurement
dc1 = mag2db(0.885/0.115)/2; % percentage in the other output in db (100% - 12% = 88%)
splice2 = -0.04; %l loss in dB
wdm1 = -0.1; % insertion loss from wdm in 1550nm
spliceFiber1 = -0.03; % loss in dB from erbium fiber splice

% Losses for I_z
spliceFiber2 = -0.14;
wdm2 = -0.1;
splice3 = -0.06;    
splice4 = -0.01;
dc2  = mag2db(100/88.5)/2; % 100% represented in db
cor = 0; % correction factor -1.8
% Erbium doped fiber specs
z = 4e-2; % 15cm
A = pi*((6.12e-6)/2)^2; % m^2

%% INPUT Laser diode characterization current x power

thLaserDiode = 32; % mA
% P_pump = = 0.5326*current - 16.64

%% INPUT DATA INTO 3D VARIABLE (P0, Pz, current)

% data(:,:,1) = xlsread('acquisition6_ER30.xlsx','amplifier','A3:C22')*10^-3;
% data(:,:,2) = xlsread('acquisition6_ER30.xlsx','amplifier','D3:F22')*10^-3;
% data(:,:,3) = xlsread('acquisition6_ER30.xlsx','amplifier','G3:I22')*10^-3;
% data(:,:,4) = xlsread('acquisition6_ER30.xlsx','amplifier','J3:L22')*10^-3;
% data(:,:,5) = xlsread('acquisition6_ER30.xlsx','amplifier','M3:O22')*10^-3;
% data(:,:,6) = xlsread('acquisition6_ER30.xlsx','amplifier','P3:R22')*10^-3;
data(:,:,1) = xlsread('acquisition7_DF1500Y.xlsx','amplifier','S3:U22')*10^-3;

%% Converting measured input and output to actual values after losses (Watts)

n = size(data(:,:,:),3);
for i=1:n
    data(:,2,i) = data(:,2,i)*10^(( dc1 + splice2 + wdm1 + spliceFiber1) / 10) ;
    data(:,3,i) = data(:,3,i)*10^((-spliceFiber2 -wdm2 -splice3 -splice4 +dc2 - cor) /10);
end

%%
% plots from linear fitting to find saturation intensity and 
% low signal gain value.
figure('Units','centimeter','Position',[0 11 width height],'PaperPositionMode','auto')
for i = 1:n

    I0 = data(:,2,i)/A;
    Iz = data(:,3,i)/A;

    % calculation of parameters
    x = Iz-I0;
    y = log(Iz./I0);

%     P = polyfit(x,y,1);
    P = polyfit(x,y,1);
    yfit = P(1)*x + P(2);
    Is(i) = (-1/P(1));  % in W/m^2
    alpha0(i) = P(2)/z; % m^-1

    % figure
    plot(x,y,'k.','MarkerSize',8);
    hold on
    % plot(x,yfit,'k','Color',[0 0 0]+0.5)
    graph(i) = plot(x,yfit);
end


legend([graph(1) graph(2) graph(3) graph(4) graph(5) graph(6) graph(7)],...
     [num2str(data(1,1,1)*1000) 'mA'],...
     [num2str(data(1,1,2)*1000) 'mA'],...
     [num2str(data(1,1,3)*1000) 'mA'],...
     [num2str(data(1,1,4)*1000) 'mA'],...
     [num2str(data(1,1,5)*1000) 'mA'],...
     [num2str(data(1,1,6)*1000) 'mA'],...
     [num2str(data(1,1,7)*1000) 'mA'],'Location','Best')
title('Amplifier fitting curve','Interpreter','LaTeX')

grid

disp('Is:')
disp(Is')
disp('alpha0:')
disp(alpha0')
%% plot of gain x input signal

%gain = 10*log10(output/input)
figure('Units','centimeter','Position',[10 11 width height],'PaperPositionMode','auto')
hold on
for i = 1:n
    gain{i} = 10*log10(data(:,3,i)./data(:,2,i));
%     input{i} = 10*log10(data(:,2,i)) + 30; %input power in dBm
    input{i} = data(:,2,i); %input power in W
    plot(input{i},gain{i},'-') %input x gain 
%     fitExp{i} = fit(input{i},gain{i},'power2');
%     plot(fitExp{i})
end
legend([num2str(data(1,1,1)*1000) ' mA'],[num2str(data(1,1,2)*1000) ' mA'],...
        [num2str(data(1,1,3)*1000) ' mA'],[num2str(data(1,1,4)*1000) ' mA'],...
        [num2str(data(1,1,5)*1000) ' mA'],[num2str(data(1,1,6)*1000) ' mA'],...
        [num2str(data(1,1,7)*1000) ' mA'],'Location','Best')
   
xlabel('Input signal [W]','Interpreter','LaTeX')
ylabel('gain [dB]','Interpreter','LaTeX')
title('Input x Gain','Interpreter','LaTeX')
grid


%% plot of gain x output signal

%gain = 10*log10(output/input)
figure('Units','centimeter','Position',[0 1 width height],'PaperPositionMode','auto')
hold on
for i = 1:n
    gain{i} = 10*log10(data(:,3,i)./data(:,2,i));
%     output{i} = 10*log10(data(:,3,i)) + 30; %output power in dBm
    output{i} = data(:,3,i);
    plot(output{i},gain{i}) %output x gain 
end

legend([num2str(data(1,1,1)*1000) ' mA'],[num2str(data(1,1,2)*1000) ' mA'],...
        [num2str(data(1,1,3)*1000) ' mA'],[num2str(data(1,1,4)*1000) ' mA'],...
        [num2str(data(1,1,5)*1000) ' mA'],[num2str(data(1,1,6)*1000) ' mA'],...
        [num2str(data(1,1,7)*1000) ' mA'],'Location','Best')

xlabel('Output signal [W]','Interpreter','LaTeX')
ylabel('gain [dB]','Interpreter','LaTeX')
title('Output x Gain','Interpreter','LaTeX')
grid

%% plot of input x output in dbm

figure('Units','centimeter','Position',[10 1 width height],'PaperPositionMode','auto')
hold on
for i = 1:n
    input{i} = 10*log10(data(:,2,i)) + 30; %output power in dBm
    output{i} = 10*log10(data(:,3,i)) + 30; %output power in dBm
    plot(input{i},output{i}) %output x gain 
end

legend([num2str(data(1,1,1)*1000) ' mA'],[num2str(data(1,1,2)*1000) ' mA'],...
        [num2str(data(1,1,3)*1000) ' mA'],[num2str(data(1,1,4)*1000) ' mA'],...
        [num2str(data(1,1,5)*1000) ' mA'],[num2str(data(1,1,6)*1000) ' mA'],...
        [num2str(data(1,1,7)*1000) ' mA'],'Location','Best')

xlabel('Input signal [dBm]','Interpreter','LaTeX')
ylabel('Output [dBm]','Interpreter','LaTeX')
title('Input x Output in dBm','Interpreter','LaTeX')
grid

%% plot of input x output in W

figure('Units','centimeter','Position',[20 1 width height],'PaperPositionMode','auto')
hold on
for i = 1:n
    input{i} = data(:,2,i); %output power in W
    output{i} = data(:,3,i); %output power in W
    plot(input{i},output{i}) %output x gain 
end

legend([num2str(data(1,1,1)*1000) ' mA'],[num2str(data(1,1,2)*1000) ' mA'],...
        [num2str(data(1,1,3)*1000) ' mA'],[num2str(data(1,1,4)*1000) ' mA'],...
        [num2str(data(1,1,5)*1000) ' mA'],[num2str(data(1,1,6)*1000) ' mA'],...
        [num2str(data(1,1,7)*1000) ' mA'],'Location','Best')
    
xlabel('Input signal [W]','Interpreter','LaTeX')
ylabel('Output [W]','Interpreter','LaTeX')
title('Input x Output in Watts','Interpreter','LaTeX')
grid

%% INPUT Gain x Pump power data (P0,I_pump,Pz)
gainPump(:,:,1) = xlsread('acquisition7_DF1500Y.xlsx','gain','F3:H22')*10^-3; % low Pin
gainPump(:,:,2) = xlsread('acquisition7_DF1500Y.xlsx','gain','I3:K22')*10^-3; % mid Pin 
% gainPump(:,:,3) = xlsread('acquisition6_ER30.xlsx','gain','I3:K22')*10^-3; % high Pin 

%% Plot pump x gain
figure('Units','centimeter','Position',[30 1 width height],'PaperPositionMode','auto')
hold on
N = size(gainPump(:,:,:),3); % number of 'pages' in the 3D matrix
for i = 1:N
    gainPump(:,4,i) = gainPump(:,2,i)*(10^3)*0.5326 -16.64; % converting current to optical power;
    gainPump(:,1,i) = gainPump(:,1,i)*10^(( dc1 + splice2 + wdm1 + spliceFiber1) / 10) ;
    gainPump(:,3,i) = gainPump(:,3,i)*10^((-spliceFiber2 -wdm2 -splice3 -splice4 +dc2) /10);
    gain1(:,i) = 10*log10((gainPump(:,3,i))/gainPump(1,1,i)); 
    plot(gainPump(3:end,2,i),gain1(3:end,i))
end

xlabel('Pump current [mA]','Interpreter','LaTeX')
ylabel('Gain [dB]','Interpreter','LaTeX')
title('Pump x Gain','Interpreter','LaTeX')

% legend(['$P_0=$' num2str(gainPump(1,1,1)*1000,'%10.3f') 'mW'],...
%        ['$P_0=$' num2str(gainPump(1,1,2)*1000,'%10.3f') 'mW'],...
%        ['$P_0=$' num2str(gainPump(1,1,3)*1000,'%10.3f') 'mW'],...
%         'Location','SouthEast')

grid
 
Ppump = gainPump(:,4,:)*10^-3;
%zeroing negative values - meaning that there is no laser yet.
Ppump(Ppump < 0) = 0; 

figure('Units','centimeter','Position',[30 11 width height],'PaperPositionMode','auto')
hold on
% Efficiency x pump 
for i=1:N
    eff_n(:,i) = ((gainPump(:,3,i)-gainPump(1,1,i))./Ppump(:,:,i)) *100; %pump efficiency
    plot(Ppump(:,:,1),eff_n(:,i))
%     plot(Ppump(:,:,1),eff_n(:,i),'k.','MarkerSize',8)
%     efficiencyCurve(:,1) = fit(Ppump(:,:,1),eff_n,'linearinterp');
%     plot(efficiencyCurve,'k')
end
ylabel('\%','Interpreter','LaTeX')
xlabel('Pump [W]','Interpreter','LaTeX')

% legend(['$P_0=$' num2str(gainPump(1,1,1)*1000,'%10.3f') 'mW'],...
%        ['$P_0=$' num2str(gainPump(1,1,2)*1000,'%10.3f') 'mW'],...
%        ['$P_0=$' num2str(gainPump(1,1,3)*1000,'%10.3f') 'mW'],...
%         'Location','Best')
% ylim([0 inf])
grid
    
%% pump vs saturation intensity
figure('Units','centimeter','Position',[20 11 width height],'PaperPositionMode','auto')    

for i=1:n
    pump(i) = data(1,1,i);
end
    
plot(pump,Is,'k.','MarkerSize',8)
linFitIs = fit(pump',Is','poly1');    
hold on
plot(linFitIs)
title('Pump x $I_s$','Interpreter','LaTeX')
ylabel('Saturation Intensity [$W/m^2$]','Interpreter','LaTeX')
xlabel('Pump [A]','Interpreter','LaTeX')
grid
