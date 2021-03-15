%% Plot spectra from Advantest OSA when acquired with labview.
% This script is used to take all .lvm extension files inside one folder
% and plot each individual optical spectrum in a different plot.
clear all
close all
clc
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')

gratio = (1+sqrt(5))/2;
height = 7; %cm

disp('Choose the file path where the waveforms are:')
selpath = uigetdir
while selpath == 0
    selpath = uigetdir  %wait path selection by user
end
cd(selpath)

files = dir('*.lvm');
files = struct2table(files);
files = files(:,1);
files = table2array(files);

path = [selpath,'\'];
c = [0.3, 0.3, 0.3]; %color of the plots

for i = 1:length(files)
    filename = files{i};
    
    data{i} = importdata(filename);
    y{i} = data{i}(:,2); %dBm
    x{i} = data{i}(:,3); %mx
    current(i) = data{i}(1,4); %mA
    peak(i) = data{i}(1,5);
    power(i) = data{i}(1,6);
    
    figure('Name', [filename(1:end-4), '_spec'],...
        'units','centimeter','position',[1 1 height*gratio height]);
    plot(x{i},y{i},'color',c)
    grid minor
    xlabel('Wavelength [m]','interpreter','latex')
    ylabel('Optical power [dBm]','interpreter','latex')
    xlim([x{i}(1) x{i}(end)])
    ylim([min(y{i})-5 max(y{i})+5])
end

 %% save spectra   
    
if ~exist('spec', 'dir')
    mkdir('spec')
end

plot_path = [path,'spec']
cd(plot_path)

size = [height*gratio height]; %cm
paperunits='centimeters';

figHandles = findall(0,'Type','figure'); 
 
% Loop through figures 2:end
for i = 1:numel(figHandles)
    
    set(figHandles(i),'paperunits',paperunits,'paperposition',[0 0 size]);
    set(figHandles(i), 'PaperSize', size);
    
%     print(figHandles(i), [figHandles(i).Name,'.pdf'],'-dpdf')
    print(figHandles(i), [figHandles(i).Name,'.svg'],'-dsvg')
    print(figHandles(i), [figHandles(i).Name,'.eps'],'-depsc')
    print(figHandles(i), [figHandles(i).Name,'.png'],'-dpng')

end


   
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    