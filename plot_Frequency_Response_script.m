%% This code calculates the signal of a low index modulation technique 
% in a Michelson interferometer and plot the gain and phase 
% by frequency.

%% Data import into cells
clear
close all
clc

disp('Choose the file path')
selpath = uigetdir
while selpath == 0
    selpath = uigetdir  %wait path selection by user
end
cd(selpath)
dir(selpath)


num_acq = 2; 
%load files containing AV values
for i=1:num_acq
    av{i} = strcat(num2str(i),'AV.mat');
    load(av{i});
   if i==1
       v1 = V1;
       v2 = V2;
   else
    v1 = vertcat(v1,V1)
    v2 = vertcat(v2,V2)
   end
end


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
% i=i-1;
noffiles = length(data)
% lastfile=regexp(filename,'\d+','match');
% lastfile=str2double(cat(1,lastfile{:}))

%% Calculation to all data files with Standard deviation automatically

figure('Units','centimeter','Position',[10 10 14 10.5],'PaperPositionMode','auto')
figure('Units','centimeter','Position',[25 10 14 10.5],'PaperPositionMode','auto')

for i=1:noffiles

A = (v1(i) + v2(i))/2;
V = (v1(i) - v2(i))/(2*A);

% experiment info
fiber_length = 10.172; %m
lambda = 1536; %nm

x{i} = (abs(Vmax{i} - Vmin{i}))./(2*A*V); %check TCC for reference
gain{i} = x{i}./Vin{i}; % rad/V
L{i}= gain{i}*lambda./(4*pi);
F{i} = Freq{i}/1000; %[kHz]
% F{i} = Freq{i}; %[Hz]
scale_factor{i} = gain{i}./fiber_length; % rad/V/m


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


%% 1 ------ calculation of mean and standard deviation among data sets

for i=1:10
    m_gain(:,i) = gain{i}; %making a matrix of gain
    m_phase(:,i) = phase{i};
    m_length(:,i) = scale_factor{i};
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

% 2 ------ calculation of mean and standard deviation among data sets

for i=1:10
    mm_gain(:,i) = gain{i+10}; %making a matrix of gain
    mm_phase(:,i) = phase{i+10};
    mm_length(:,i) = scale_factor{i+10};
end

for i=1:length(mm_gain)
    mean_gain2(i) = mean(mm_gain(i,:));  %mean vector of gain
    std_gain2(i) = std(mm_gain(i,:));    %standard deviation vector of gain
end
mean_gain2 = mean_gain2';        %arranging to 1 column
std_gain2 = std_gain2';

for i=1:length(mm_phase)
    mean_phase2(i) = mean(mm_phase(i,:));   %mean vector of phase
    std_phase2(i) = std(mm_phase(i,:));     %standard deviation vector of phase
end
mean_phase2 = mean_phase2';       %arranging to 1 column
std_phase2 = std_phase2';

for i=1:length(mm_length)
    mean_length2(i) = mean(mm_length(i,:));   %mean vector of phase
    std_length2(i) = std(mm_length(i,:));     %standard deviation vector of phase
end
mean_length2 = mean_length2';       %arranging to 1 column
std_length2 = std_length2';

% Sum of means and Stds

mean_gain = [mean_gain ; mean_gain2];
mean_phase = [mean_phase ; mean_phase2];
mean_length = [mean_length ; mean_length2];

std_gain = [std_gain ; std_gain2];
std_phase = [std_phase ; std_phase2];
std_length = [std_length ; std_length2];

freq = [F{1};F{11}];

%% Plot figures with errorbar or error shadded area (way prettier!)
% close all
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')

figure('Units','centimeter','Position',[10 10 10 7],'PaperPositionMode','auto')
shadedErrorBar(freq,mean_gain,std_gain,'lineprops','-k')
    ylim([0 10])
    xlim([0 5.1])
    xlabel('Frequency [kHz]','Color','k','interpreter','LaTeX');
    ylabel('Scale factor [rad/V]','Color','k','interpreter','LaTeX');
    
        
    L = fiber_length; 
    ax = gca;
    rad_v = ax.YTick; % ticks from yyaxis left
    rad_v_m = rad_v/L;
    rad_v_m = round(rad_v_m,2);
    rad_v_m = num2str(rad_v_m, '%.2f    ');%to number
    rad_v_m = strsplit(rad_v_m); %converting each string to cell
    lim = ax.YLim

    yyaxis right
    set(gca,'YColor','k')
%     xlim([50 300])
    set(gca,'YLim',lim)
    set(gca,'YTickLabel',rad_v_m)
    ylabel('Normalized scale factor[rad/V/m]','Color','k','interpreter','LaTeX');
    grid
    box on
        
    ax1 = gca;

figure('Units','centimeter','Position',[25 10 10 7],'PaperPositionMode','auto')
    shadedErrorBar(freq,mean_phase,std_phase,'lineprops','-k')
    ylim([-180 180])
    xlabel('Frequency [kHz]','Color','k','interpreter','LaTeX');
    % xlim([0 5.1])
    ylabel('Phase [degree]','Color','k','interpreter','LaTeX');
    % set(gca, 'XScale', 'log')
    grid on
    box on
    
    % making the two boxes have the same size
    ax2 = gca;
    pos=get(ax1,'position');
    set(ax2,'position',pos);
%% Post processing the figures

clear ax ax1 ax2 rad_v rad_v_m
%% Making inset from 50Hz to 300 Hz
figure(3)
axes('position',[.350 .550 .40 .35])
box on

ax1 = shadedErrorBar(freq*1000, mean_gain, std_gain,...
    'lineprops','-k');
    xlabel('Frequency [Hz]','Color','k','interpreter','LaTeX');
    ylabel('Scale factor [rad/V]','Color','k','interpreter','LaTeX');
    xlim([50 200])
    set(gca,'FontSize',8)
%     axis tight

     
    
    L = fiber_length; 
    ax = gca;
    rad_v = ax.YTick; % ticks from yyaxis left
    rad_v_m = rad_v/L;
    rad_v_m = round(rad_v_m,2);
    rad_v_m = num2str(rad_v_m, '%.2f    ');%to number
    rad_v_m = strsplit(rad_v_m); %converting each string to cell
    lim = ax.YLim

    yyaxis right
    set(gca,'YColor','k')
    xlim([50 200])
    set(gca,'YLim',lim)
    set(gca,'YTickLabel',rad_v_m)
    ylabel('[rad/V/m]','Color','k','interpreter','LaTeX');
    grid

%     
%     hold all
%     yyaxis right
%     plot(freq*1000, mean_length,'Color','none')
%     set(gca,'FontName','latex');
%     % ylim([0 (10*lambda/(4*pi))])
%     ylabel('[rad/V/m]','Color','k','interpreter','LaTeX');
%     set(gca,'YColor','k')
%     set(gca,'YLim',lim)
%     xlim([50 300])
% %     ax=gca;
% %     r1=ax.YAxis(1);
% %     r2=ax.YAxis(2);
% %     linkprop([r1 r2],'Limits');
%     grid on
%     box on
    
 
%% Save final plots 3 and 4 as is.


size = [10 7] %cm
paperunits='centimeters';

set(figure(3),'paperunits',paperunits,...
              'paperposition',[0 0 size],...
              'PaperSize', size);
print(figure(3), 'scale_factor.pdf','-loose','-dpdf')
print(figure(3), 'scale_factor.eps','-loose','-depsc')

set(figure(4),'paperunits',paperunits,...
              'paperposition',[0 0 10 7],...
              'PaperSize', size);
print(figure(4), 'phase.pdf','-loose','-dpdf')
print(figure(4), 'phase.eps','-loose','-depsc')





















