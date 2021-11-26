function save_open_fig(path, fig_size, ext)
% This function saves all the opened figures at the moment in MATLAB and saves in the indicated folder, inside a 'plots' folder.
% The name of each file is the name of the figure define in: figure('name','...')
% path: 'D:\Users\...'
% fig_size: [width  height]
% ext:    1 - pdf
%         2 - eps
%         3 - png
%         4 - ALL FORMATS
%         5 - DO NOT SAVE
%
% save_open_fig(path, fig_size, format)
    if ext == 5
        fprintf('Figures were NOT saved!\n')
    return 

    paperunits='centimeters';
    plot_path = [path,'\plots']
    figHandles = findall(0,'Type','figure'); 
    initial_path = pwd;

    cd(path)

    if ~exist('plots', 'dir')
        mkdir('plots')
    end
    
    cd(plot_path)
         
    for i = 1:numel(figHandles)
        set(figHandles(i),'paperunits', paperunits, 'paperposition', [0 0 fig_size]);
        set(figHandles(i), 'PaperSize', fig_size);
        
        if ext == 1
            print(figHandles(i), [figHandles(i).Name,'.pdf'],'-dpdf')
        elseif ext == 2
            print(figHandles(i), [figHandles(i).Name,'.eps'],'-depsc')
        elseif ext == 3
            print(figHandles(i), [figHandles(i).Name,'.png'],'-dpng')
        elseif ext == 4
            print(figHandles(i), [figHandles(i).Name,'.pdf'],'-dpdf')
            print(figHandles(i), [figHandles(i).Name,'.eps'],'-depsc')
            print(figHandles(i), [figHandles(i).Name,'.png'],'-dpng')
        end
    end

    cd(initial_path)
    fprintf('Done saving the figures!\n')
end