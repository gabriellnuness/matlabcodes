%% This code calculates the signal of a low index modulation technique 
% in a Michelson interferometer and plot the gain and phase 
% by frequency.

%% Data import into cells
clc
% clear
disp('Choose the file path')
selpath = uigetdir
while selpath == 0
    selpath = uigetdir  %wait path selection by user
end
cd(selpath)
dir(selpath)

%collection of data in cell format, it is almost like a 3D array.
i=1;
%'data' is the default name of the files
while exist(['data',num2str(i),'.lvm'], 'file') == 2 %while file exists
filename = ['data',num2str(i),'.lvm'];
data{i} = dlmread(filename);
Vmax{i} = data{i}(:,1);    %Max amp in low index modulation
Vmin{i} = data{i}(:,2);    %Min amp in low index modulation
phase{i} = data{i}(:,3);    %Phase delay between input and interferometric signals.
for n=1:length(phase{i})-1   %conditioning phase
if phase{i}(n)>180 & phase{i}(n)<360
   phase{i}(n) = phase{i}(n) -360;
end
end
Vin{i} = data{i}(:,4);     %Voltage from func generator
for n=1:length(Vin{i})-1   %conditioning Vin accordingly to experiment
if Vin{i}(n)<0.05
    Vin{i}(n) = 0.05;
end
if Vin{i}(n) == [1.38777900000000e-17]
    Vin{i}(n)= 0.05;
end
end
Freq{i} = data{i}(:,5);    %Frequency of measurement
error{i} = data{i}(:,6);    %1 if minimum voltage was not small enough to low index,
THD{i} = data{i}(:,7);     %Harmonic Distortion in interferometric signal
Vr1{i} = data{i}(:,8);     %Vmax with frequency applied
Vr2{i} = data{i}(:,9);    %Vmax with frequency applied
i=i+1;
end
i=i-1;
noffiles = length(data)
% lastfile=regexp(filename,'\d+','match');
% lastfile=str2double(cat(1,lastfile{:}))

%% Calculation to all data files with Standard deviation automatically
V1 = xlsread('AV.xlsx','AV','A:A');
V2 = xlsread('AV.xlsx','AV','B:B');%when all AV values are saved already
%calculation of gain and phase to all data sets

figure('Units','centimeter','Position',[10 10 14 10.5],'PaperPositionMode','auto')
figure('Units','centimeter','Position',[25 10 14 10.5],'PaperPositionMode','auto')

for i=1:noffiles
    
% to insert AV values manually during first time
% V1(i) = input(['V1 for data',num2str(i),': ']); % V1 = 8.45215; myRIO AV
% V2(i) = input(['V2 for data',num2str(i),': ']); % V2 = 0.727539; myRIO AV    
%    
A = (V1(i) + V2(i))/2;
V = (V1(i) - V2(i))/(2*A);
x{i} = (abs(Vmax{i} - Vmin{i}))./(2*A*V); %check TCC for reference
gain{i} = x{i}./Vin{i}; % rad/V
lambda = 1536; %nm
L{i}= gain{i}*lambda./(4*pi);
F{i} = Freq{i}/1000; %[kHz]

%#########################################  individual plot
% figure('Units','centimeter','Position',[10 10 14 10.5],'PaperPositionMode','auto')
figure(1)
plot(F{i},gain{i},'.-','DisplayName',['data',num2str(i)])
xlabel('Frequency [kHz]','Color','k','interpreter','LaTeX');
ylim([0 8])
% xlim([0.5 5])
ylabel('Gain [rad/V]','Color','k','interpreter','LaTeX');
% title(['plot data',num2str(i)])
legend('-DynamicLegend');
grid
hold all

% figure('Units','centimeter','Position',[25 10 14 10.5],'PaperPositionMode','auto')
figure(2)
plot(F{i},phase{i},'.-','DisplayName',['data',num2str(i)])
ylim([-180 180])
xlabel('Frequency [kHz]','Color','k','interpreter','LaTeX');
% xlim([0.5 5])
ylabel('Phase [degree]','Color','k','interpreter','LaTeX');
% title(['plot data',num2str(i)])
legend('-DynamicLegend');
hold all
grid

end

%calculation of mean and standard deviation among data sets
for i=1:noffiles
m_gain(:,i) = gain{i}; %making a matrix of gain
m_phase(:,i) = phase{i};
m_length(:,i) = L{i};
end
for i=1:length(m_gain)
mean_gain(i) = mean(m_gain(i,:));  %mean vector of gain
std_gain(i) = std(m_gain(i,:));    %standard deviation vector of gain
end
mean_gain = mean_gain';        %arranging to 1 column
std_gain = std_gain';
for i=1:length(m_phase)
mean_phase(i) = mean(m_phase(i,:));   %mean vector of phase
std_phase(i) = std(m_phase(i,:));     %standard deviation vector of phase
end
mean_phase = mean_phase';       %arranging to 1 column
std_phase = std_phase';
for i=1:length(m_length)
mean_length(i) = mean(m_length(i,:));   %mean vector of phase
std_length(i) = std(m_length(i,:));     %standard deviation vector of phase
end
mean_length = mean_length';       %arranging to 1 column
std_length = std_length';

% %% Saving plot values in variables to join multiple measurements.
% i = 2; %sequence of plot
% cellF{i} = F{1};
% cellmean_gain{i} = mean_gain;
% cellstd_gain{i} = std_gain;
% cellmean_length{i} = mean_length;
% cellmean_phase{i} = mean_phase;
% cellstd_phase{i} = std_phase;
% %% Joining the variables
% n = 2; %number of sequence to plot
% mean_gain = [cellmean_gain{n-1};cellmean_gain{n}];
% std_gain = [cellstd_gain{n-1};cellstd_gain{n}];
% mean_length = [cellmean_length{n-1};cellmean_length{n}];
% mean_phase = [cellmean_phase{n-1};cellmean_phase{n}];
% std_phase = [cellstd_phase{n-1};cellstd_phase{n}];
% F{1} = [cellF{n-1};cellF{n}];

%% Plot figures with errorbar or error shadded area (way prettier!)
% close all
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
% belize = [41/256 128/256 185/256];
%shaded errorbar plots
figure('Units','centimeter','Position',[10 10 14 10.5],'PaperPositionMode','auto')
shadedErrorBar(F{1},mean_gain,std_gain,'lineprops','.-k')
xlabel('Frequency [kHz]','Color','k','interpreter','LaTeX');
ylim([0 10])
% xlim([0 5.1])
ylabel('Gain [rad/V]','Color','k','interpreter','LaTeX');

hold all
yyaxis right
plot(F{1}, mean_length,'Color','none')
set(gca,'FontName','latex');
ylim([0 (10*lambda/(4*pi))])
ylabel('Gain [nm/V]','Color','k','interpreter','LaTeX');
set(gca,'YColor','k')
ax=gca;
r1=ax.YAxis(1);
r2=ax.YAxis(2);
% linkprop([r1 r2],'Limits');
% set(gca, 'XScale', 'log')
grid

figure('Units','centimeter','Position',[25 10 14 10.5],'PaperPositionMode','auto')
shadedErrorBar(F{1},mean_phase,std_phase,'lineprops','-k')
ylim([-180 180])
xlabel('Frequency [kHz]','Color','k','interpreter','LaTeX');
% xlim([0 5.1])
ylabel('Phase [degree]','Color','k','interpreter','LaTeX');
% set(gca, 'XScale', 'log')
grid 

%% individual calculation and plot of a chosen data file
% i = 1;  %chose which datai.lvm to analyze
% 
% % V1 = input(['V1 for data',num2str(i),': ']); % V1 = 8.45215; myRIO AV
% % V2 = input(['V2 for data',num2str(i),': ']); % V2 = 0.727539; myRIO AV    
% A = (V1(i) + V2(i))/2;
% V = (V1(i) - V2(i))/(2*A);
% x{i} = (abs(Vmax{i} - Vmin{i}))./(2*A*V); %check TCC for reference
% gain{i} = x{i}./Vin{i}; % rad/V
% lambda = 1536; %nm
% L{i}= gain{i}*lambda./(4*pi);
% F{i} = Freq{i}/1000; %[kHz]
% 
% 
% figure('Units','centimeter','Position',[10 10 14 10.5],'PaperPositionMode','auto')
% plot(F{i},gain{i},'-k')
% xlabel('Frequency [kHz]','Color','k','interpreter','LaTeX');
% ylim([0 8])
% xlim([0.5 5])
% ylabel('Gain [rad/V]','Color','k','interpreter','LaTeX');
% 
% hold all
% yyaxis right
% plot(F{i}, L{i},'Color','none')
% set(gca,'FontName','latex');
% ylim([0 (8*lambda/(4*pi))])
% ylabel('Gain [nm/V]','Color','k','interpreter','LaTeX');
% set(gca,'YColor','k')
% ax=gca;
% r1=ax.YAxis(1);
% r2=ax.YAxis(2);
% linkprop([r1 r2],'Limits');
% grid
