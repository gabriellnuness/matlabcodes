%% This code does the math for linearity of FOMMC acquired 
% 2020.11.06 for 30 Hz and 150 Hz
clear all
close all
clc
%%

set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')

Vmax = 4.5;
Vmin = 0.22;
freq = [30;150];

for i = 1:2
    filename{i} = ['linearity_',num2str(freq(i)),'Hz.csv'];
    data = xlsread(filename{i});

    Vin{i} = data(:,1); % Volts
    Vsignal_max{i} = data(:,2);
    Vsignal_min{i} = data(:,3);

    rad{i} = (Vsignal_max{i} - Vsignal_min{i})./((Vmax-Vmin));


        % fitting
    x = Vin{i};
    y = rad{i};
    [f,s] = fit(x,y,'poly1');
    Rsqr{i} = s.rsquare
    fit_slope{i} = f.p1  % rad/V
    fit_intercept{i} = f.p2; 
    ff{i} = f;
end
%     figure('Units','centimeter','Position',[0 1 6.5*1.4 6.5],...
%            'PaperPositionMode','auto')
%         plot(Vin,rad,'.k')
%             hold on
%         p = plot(f)
%             xlabel('Input [mV]','Interpreter','Latex','FontSize',10)
%             ylabel('Output [rad]','Interpreter','Latex','FontSize',10)
%             legend('1 kHz',['$R^2$ = ' num2str(Rsqr)],'Location','NorthWest',...
%                     'Interpreter','Latex')
%             xlim([40,180])
%             ylim([0.1,0.7])
%             set(p,'Color','black')
%         grid
    
    %% Plot second axis with strain units
% figure('Units','centimeter','Position',[0 1 6.5*1.4 6.5],...
%        'PaperPositionMode','auto')
%     xlim([0.8, 5.2])
% 
%     yyaxis left
%     plot(Vin,rad,'.k')
%     hold on
%     p = plot(f);
%     xlabel('Input [V]','Interpreter','Latex','FontSize',10)
%     ylabel('Output [rad]','Interpreter','Latex','FontSize',10)
%     legend([num2str(freq),' Hz'],['$R^2$ = ' num2str(Rsqr)],'Location','NorthWest',...
%             'Interpreter','Latex')
% %     ylim([0.1,0.7])
%     set(p,'Color','black')
%     set(gca,'YColor','k')
% 
% L = 10e-3; % initial length of fiber
% lambda = 1536e-9; %laser wavelength in meters
% n = 1.5 ;
% 
% ax = gca;
% rad = ax.YTick; % ticks from yyaxis left to use as variable
% dL = rad*lambda/(4*pi*n); %variation in meters
% st = dL/L;  % >>>> strain
% n_st = round(st*10^6,3); %convertion to nanostrains with 2 decimals
% n_st = num2str(n_st); %to number
% n_st = strsplit(n_st); %converting each string to cell
% lim = ax.YLim;
% 
% %inclination in strain/mV
% st_slope = fit_slope*lambda/(4*pi*n);
% st_slope = st_slope/L   % E/V
% n_st_slope = round(st_slope*10^6,4) %uE/V
% 
% yyaxis right
%     set(gca,'YColor','k')
%     set(gca,'YLim',lim)
%     set(gca,'YTickLabel',n_st)
%     ylabel('Strain [$\mu\varepsilon$]','Interpreter','Latex','FontSize',10)
% %     xlim([40,180])
%     grid
 %% show fitting results in plot
% fitresults = f;
% coeffs = coeffnames(fitresults);
% coeffvals= coeffvalues(fitresults);
% ci = confint(fitresults,0.95);
% str1 = sprintf('\n %s = %0.3f   (%0.3f   %0.3f)',coeffs{1},coeffvals(1),ci(:,1));
% str2 = sprintf('\n %s = %0.3f   (%0.3f   %0.3f)',coeffs{2},coeffvals(2),ci(:,2));
% annotation('textbox',[.4 .15 .5 .2],'String',['Coefficients (with 95% confidence bounds): ', str1, str2]);
    


%% Plot both graphs in same figure
figure('Units','centimeter','Position',[0 1 10 7],...
       'PaperPositionMode','auto')
 plot(Vin{1},rad{1},'.k')
    xlim([0.8, 5.2])
    hold on
    p = plot(ff{1});

    set(p,'Color',[.3 .3 .3])
    
    set(gca,'YColor','k')
plot(Vin{2},rad{2},'*k', 'markersize',3)
    p = plot(ff{2},'--');
    set(p,'Color',[.3 .3 .3])
    set(gca,'YColor','k')
    legend([num2str(freq(1)),' Hz'],['$y= $',num2str(ff{1}.p1,2),'$\cdot x+$',num2str(ff{1}.p2,2)],...
           [num2str(freq(2)),' Hz'],['$y= $',num2str(ff{2}.p1,2),'$\cdot x+$',num2str(ff{2}.p2,2)],...
        'Location','NorthWest','Interpreter','Latex')
    xlabel('Input amplitude [V]','Interpreter','Latex','FontSize',10)
    ylabel('Output [rad]','Interpreter','Latex','FontSize',10)   
    set(gca,'Fontsize',10)
    grid    
%%
size = [10 7];%cm
paperunits='centimeters';

set(gcf,'paperunits',paperunits,'paperposition',[0 0 size]);
set(gcf, 'PaperSize', size)
print(gcf, 'linearity_30_150_loose_Hz.pdf','-loose','-dpdf')
print(gcf, 'linearity_30_150_loose_Hz.eps','-loose','-depsc')
    
    
    
    
    
    
    
    
    
    
    