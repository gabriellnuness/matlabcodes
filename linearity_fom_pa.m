%% 1KHz
clear all
close all
clc

set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')

Vmax = 10.2;
Vmin = 0.5;
data = [50,6.1,4.1
        60,6.25,3.9
        70,6.45,3.78
        80,6.60,3.59
        90,6.77,3.42
        100,6.9,3.27
%         110,7.08,3.10
%         120,7.20,3.0
%         130,7.3,2.85
%         140,7.45,2.7
%         150,7.62,2.6
%         160,7.68,2.52
%         170,7.77,2.41
%         160,7.7,2.49
%         150,7.6,2.62
%         140,7.5,2.7
%         130,7.33,2.85
%         120,7.2,3.0
%         110,7.06,3.1
        100,6.9,3.27
        90,6.78,3.41
        80,6.6,3.6
        70,6.41,3.75
        60,6.26,3.95
        50,6.07,4.1];
    
    Vin = data(:,1); %mV
    Vin = Vin/1000; %V
    rad = (data(:,2) - data(:,3))./((Vmax-Vmin));

    
    % fitting
    x = Vin;
    y = rad;
    [f,s] = fit(x,y,'poly1');
    Rsqr = s.rsquare
    fit_slope = f.p1  % rad/mV
    fit_slope_v =  fit_slope*1000 % rad/V
    fit_intercept = f.p2; 
    
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
 figure('Units','centimeter','Position',[0 1 10 7],...
           'PaperPositionMode','auto')
    
    
%     yyaxis left
        plot(Vin,rad,'.k')
            hold on
            p = plot(f);
            xlabel('Input amplitude [V]','Interpreter','Latex','FontSize',10)
            ylabel('Output [rad]','Interpreter','Latex','FontSize',10)
            legend('1 kHz',['$y=$',num2str(f.p1,2),'$\cdot x+$',num2str(f.p2,2)],'Location','NorthWest',...
                    'Interpreter','Latex')
            ylim([0.1 max(rad)+0.1])
            set(p,'Color',[.3 .3 .3])
            set(gca,'YColor','k')
            xlim([min(Vin)-0.001 max(Vin)+0.001])

L = 10.172; % initial length of fiber in meters
lambda = 1536e-9; %laser wavelength in meters
n = 1.5 ;

ax = gca;
rad = ax.YTick; % ticks from yyaxis left to use as variable
dL = rad*lambda/(4*pi*n); %variation in meters
st = dL/L;  % >>>> strain
n_st = round(st*10^9,3); %convertion to nanostrains with 2 decimals
n_st = num2str(n_st); %to number
n_st = strsplit(n_st); %converting each string to cell
lim = ax.YLim;

%inclination in strain/mV
st_slope = fit_slope*lambda/(4*pi*n);
st_slope = st_slope/L   % E/mV
n_st_slope = round(st_slope*10^9,4) %nE/mV

set(gca,'fontsize',10)
%% Right y-axis
% yyaxis right
%     set(gca,'YColor','k')
%     set(gca,'YLim',lim)
%     set(gca,'YTickLabel',n_st)
%     ylabel('Strain [n$\varepsilon$]','Interpreter','Latex','FontSize',10)
%     xlim([40,180])
    grid
%     ax2 = gca
%     pos = [0.1300    0.1419    0.7624    0.7831]
%     set(ax2,'position',pos)
    
    
 %%
size = [10 7]; %cm
paperunits='centimeters';

set(gcf,'paperunits',paperunits,'paperposition',[0 0 size]);
set(gcf, 'PaperSize', size);
print(gcf, 'linearity_pzt.pdf','-loose','-dpdf')
print(gcf, 'linearity_pzt.eps','-loose','-depsc')
    
    
    
    
    
    
    
    
    