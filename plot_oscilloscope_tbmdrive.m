% This script invokes the functions import_wave.m and 
% FFT_plot.m 
% It is used to plot and save the multiple waveforms that 
% are in the same folder, with extension .csv collected by labVIEW VI.
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
    wave{i} = readmatrix(filename);
    wave{i} = wave{i}(3:end,:);
    [~,col]=size(wave{i});
    
    
    time{i} = wave{i}(:,1);
    time{i} = time{i}-time{i}(1);
    v1{i} = wave{i}(:,2);
    v2{i} = wave{i}(:,3);
    v3{i} = wave{i}(:,4);
    if col == 5
        v4{i} = wave{i}(:,5);
    end
    
    %v1
    % plot waveform
    figure('Name', [filename(1:end-4), '_wave_and_FFT'],...
        'units','centimeter','position',[1 1  40 25]);
        subplot(4,2,1)
        plot(time{i}, v1{i},'Color', c)
        grid on
        subplot(4,2,2)
        FFT_plot(time{i}, v1{i}, c)
        xlim([0 40])
        grid on
        
        subplot(4,2,3)
        plot(time{i}, v2{i},'Color', c)
        grid on
        subplot(4,2,4)
        FFT_plot(time{i}, v2{i}, c)
        xlim([0 40])
        grid on
                
        subplot(4,2,5)
        plot(time{i}, v3{i},'Color', c)
        grid on
        subplot(4,2,6)
        FFT_plot(time{i}, v3{i}, c)
        xlim([0 40])
        grid on
        
        if col==5
            subplot(4,2,7)
            plot(time{i}, v4{i},'Color', c)
            grid on
            subplot(4,2,8)
            FFT_plot(time{i}, v4{i}, c)
            xlim([0 40])
            grid on
        end
end


%% save files to folder

if ~exist('plots', 'dir')
    mkdir('plots')
end

plot_path = [path,'plots']
cd(plot_path)

size = [40  25]; %cm
paperunits='centimeters';

figHandles = findall(0,'Type','figure'); 
 
% Loop through figures 2:end
for i = 1:numel(figHandles)
    
    set(figHandles(i),'paperunits',paperunits,'paperposition',[0 0 size]);
    set(figHandles(i), 'PaperSize', size);
    
    print(figHandles(i), [figHandles(i).Name,'.pdf'],'-dpdf')
    print(figHandles(i), [figHandles(i).Name,'.eps'],'-depsc')
    print(figHandles(i), [figHandles(i).Name,'.png'],'-dpng')

end


   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
