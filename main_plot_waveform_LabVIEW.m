% This script invokes the functions import_wave.m and 
% FFT_plot.m 
% It is used to plot and save the multiple waveforms that 
% are in the same folder, with extension .csv
% Therefore, there must not be any other csv file inside folder.


clear all
close all
clc

disp('Choose the file path where the waveforms are:')
selpath = uigetdir
while selpath == 0
    selpath = uigetdir  %wait path selection by user
end
cd(selpath)

files = dir('*.csv');
files = struct2table(files);
files = files(:,1);
files = table2array(files);

path = [selpath,'\'];
c = [0.3, 0.3, 0.3]; %color of the plots

for i = 1:length(files)
    filename = files{i};
    wave{i} = import_wave(path,filename);
    
    time{i} = wave{i}(:,1);  %dataframe
    time{i} = table2array(time{i});
%     this function loses last 2 digits
%     time{i} = seconds(time{i} - time{i}(1)); %just ss.SSSS 
    time{i} = extractAfter(time{i}, 16);
    time{i} = str2double(time{i});
    time{i} = time{i}-time{i}(1);
    
    volts{i} = wave{i}(:,2); %mV
    volts{i} = table2array(volts{i});
    % data is cooked
    
    % plot waveform
    figure('Name', [filename(1:end-4), '_wave']);
    plot(time{i}, volts{i},'Color', c)
    xlim([time{i}(1) time{i}(end)])
    grid on
    
    % plot fft
    figure('Name', [filename(1:end-4), '_fft']);
    FFT_plot(time{i}, volts{i}, c)
    xlim([-10 600])
%     title(filename)
    grid on
      
end


%% save files to folder

if ~exist('plots', 'dir')
    mkdir('plots')
end

plot_path = [path,'plots']
cd(plot_path)

size = [10 7]; %cm
paperunits='centimeters';

figHandles = findall(0,'Type','figure'); 
 
% Loop through figures 2:end
for i = 1:numel(figHandles)
    
    set(figHandles(i),'paperunits',paperunits,'paperposition',[0 0 size]);
    set(figHandles(i), 'PaperSize', size);
    
    print(figHandles(i), [figHandles(i).Name,'.pdf'],'-dpdf')
    print(figHandles(i), [figHandles(i).Name,'.eps'],'-depsc')

end


   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
