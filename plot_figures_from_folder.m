% This script invokes the functions FFT_plot.m and save_open_fig.m 
% It is used to plot and save the multiple waveforms that 
% are in the same folder, with extension .csv collected by labVIEW VI.
% Therefore, there must not be any other csv file inside folder.

save_figures_status = 5;

set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')

initial_path = pwd;

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

% for loop to read and plot the data from each csv file 
for i = 1:length(files)
    % Importing data
    filename = files{i};
    wave{i} = readmatrix(filename);
    wave{i} = wave{i}(3:end,:);
    [~,col] = size(wave{i});
    time{i} = wave{i}(:,1);
    time{i} = time{i}-time{i}(1);

    % Creating variables
    v1{i} = wave{i}(:,2);
    v1{i} = fillmissing(v1{i},'next'); % for NaN in vector
    if col >= 3
        v2{i} = wave{i}(:,3);
    end
    if col >= 4
        v3{i} = wave{i}(:,4);
    end
    if col >= 5
        v4{i} = wave{i}(:,5);
    end

    plot_row = col-1;
    % Plotting the data in subplots
    figure('Name', [filename(1:end-4), '_wave_and_FFT'],...
        'units','centimeter','position',[1 1  30 col*5]);
        subplot(plot_row,2,1)
            plot(time{i}, v1{i},'Color', c)
                grid on
        subplot(plot_row,2,2)
            FFT_plot(time{i}, v1{i}, c)
                set(gca,'YScale','log')
                grid on
                grid minor
        if col >= 3 
            subplot(plot_row,2,3)
                plot(time{i}, v2{i},'Color', c)
                grid on
            subplot(plot_row,2,4)
                FFT_plot(time{i}, v2{i}, c)
                    set(gca,'YScale','log')
                    grid on
        end
        if col >= 4 
            subplot(plot_row,2,5)
                plot(time{i}, v3{i},'Color', c)
                    grid on
            subplot(plot_row,2,6)
                FFT_plot(time{i}, v3{i}, c)
                    set(gca,'YScale','log')
                    grid on
        end
        if col >= 5
            subplot(plot_row,2,7)
                plot(time{i}, v4{i},'Color', c)
                    grid on
            subplot(plot_row,2,8)
                FFT_plot(time{i}, v4{i}, c)
                    grid on
        end
end

%% save files to folder
cd(initial_path)
save_open_fig(selpath, [30 col*5], save_figures_status) 
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
