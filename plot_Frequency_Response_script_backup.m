%% This code calculates the signal of a low index modulation technique 
% in a Michelson interferometer and plot the gain and phase by frequency.


%% Data import and Calculation
clc
clear

disp('Choose the file path')
selpath = uigetdir
while selpath == 0
    selpath = uigetdir
end
cd(selpath)
dir(selpath)

i=1;
while exist(['data',num2str(i),'.lvm'], 'file') == 2
filename = ['data',num2str(i),'.lvm'];
data{i} = dlmread(filename);
i=i+1;

V1 = 0.285;       %AV from myRIO ramp at the beggining of measurement
V2 = 0.091;      %AV
Vmax = data(:,1);    %Max amp in low index modulation
Vmin = data(:,2);    %Min amp in low index modulation
Fase = data(:,3);    %Phase delay between input and interferometric signals.
Vin = data(:,4);     %Voltage from func generator
Freq = data(:,5);    %Frequency of measurement
erro = data(:,6);    %1 if minimum voltage was not small enough to low index,
THD = data(:,7);     %Harmonic Distortion in interferometric signal
Vr1 = data(:,8);     %Vmax with frequency applied
Vr2 = data(:,9);    %Vmax with frequency applied

end

%conditioning Vin accordingly to experiment
for i=1:length(Vin)-1
if Vin(i)<0.05
    Vin(i) = 0.05;
end
if Vin(i)== [1.38777900000000e-17]
    Vin(i)= 0.05;
end
end

A = (V1 + V2)/2;
V = (V1 - V2)/(2*A);
disp(['AV = ',num2str(A*V)]);

x = (abs(Vmax - Vmin))./(2*A*V); %check TCC for reference
Y = x./Vin; % rad/V

lambda = 1536; %nm
L= Y*lambda./(4*pi*1.5);
F=Freq;
Fk = F/1000;

%% 
%Plot figures
close all;
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')

%Gain plot
figure('Units','centimeter','Position',[10 10 14 10.5],'PaperPositionMode','auto')
yyaxis left
plot(Fk, Y, 'k')
ylim([0 max(Y)])
xlabel('Frequency [kHz]','Color','k');
xlim([0.5 5])
ylabel('Gain [rad/V]','Color','k');
hold all
set(gca,'YColor','k')
        
yyaxis right
plot(Fk, L,'k')
set(gca,'FontName','latex');
ylim([0 max(L)])
ylabel('Ganho [nm/V]','Color','k');
set(gca,'YColor','k')
ax=gca;
r1=ax.YAxis(1);
r2=ax.YAxis(2);
linkprop([r1 r2],'Limits');
grid

% Phase plot
figure('Units','centimeter','Position',[25 10 14 10.5],'PaperPositionMode','auto')
yyaxis left
plot(Fk, Fase,'k')
ylim([-180 180])
xlabel('Frequency [kHz]','Color','k');
xlim([0.5 5])
ylabel('Phase [degree]','Color','k');
hold all
set(gca,'YColor','k')

yyaxis right
plot(Fk, degtorad(Fase),'k')
set(gca,'YColor','k')
ylim([-pi pi])
ylabel('Phase [rad]','Color','k');
ax=gca;
r1=ax.YAxis(1);
r2=ax.YAxis(2);
linkprop([r1 r2],'Limits');
grid
%%