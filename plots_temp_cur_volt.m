close all
clear all
clc

%% Data import
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')

V1 = xlsread('dados_temp_cur_vol.xlsx','Plan1','A2:A28');
A1 = xlsread('dados_temp_cur_vol.xlsx','Plan1','B2:B28')*10^-3;
T1 = xlsread('dados_temp_cur_vol.xlsx','Plan1','C2:C28');

V2 = xlsread('dados_temp_cur_vol.xlsx','Plan1','E2:E28');
A2 = xlsread('dados_temp_cur_vol.xlsx','Plan1','F2:F28')*10^-3;
T2 = xlsread('dados_temp_cur_vol.xlsx','Plan1','G2:G28');

V3 = xlsread('dados_temp_cur_vol.xlsx','Plan1','I2:I28');
A3 = xlsread('dados_temp_cur_vol.xlsx','Plan1','J2:J28')*10^-3;
T3 = xlsread('dados_temp_cur_vol.xlsx','Plan1','K2:K28');

V4 = xlsread('dados_temp_cur_vol.xlsx','Plan1','M2:M28');
A4 = xlsread('dados_temp_cur_vol.xlsx','Plan1','N2:N28')*10^-3;
T4 = xlsread('dados_temp_cur_vol.xlsx','Plan1','O2:O28');

V5 = xlsread('dados_temp_cur_vol.xlsx','Plan1','Q2:Q28');
A5 = xlsread('dados_temp_cur_vol.xlsx','Plan1','R2:R28')*10^-3;
T5 = xlsread('dados_temp_cur_vol.xlsx','Plan1','S2:S28');

Vmed = xlsread('dados_temp_cur_vol.xlsx','Plan1','U2:U28');
Amed = xlsread('dados_temp_cur_vol.xlsx','Plan1','V2:V28')*10^-3; %A
Tmed = xlsread('dados_temp_cur_vol.xlsx','Plan1','W2:W28');

Vstd = xlsread('dados_temp_cur_vol.xlsx','Plan1','Y2:Y28');
Astd = xlsread('dados_temp_cur_vol.xlsx','Plan1','Z2:Z28');
Tstd = xlsread('dados_temp_cur_vol.xlsx','Plan1','AA2:AA28');


%% Resistance calculation with linear fitting
close all

% taking the average and std variation of data before fitting
meanA = mean([A1,A2,A3,A4,A5],2);
meanV = mean([V1,V2,V3,V4,V5],2);

stdA =std([A1,A2,A3,A4,A5],0,2);
stdV =std([V1,V2,V3,V4,V5],0,2);

% fitting to line and forcing to cross 0x0
f = @(p1,x) p1*x + 0 ;
[meanR,S,mu] = fit(meanA,meanV,f)

% mean of the first 3 points only
% [meanR,S,mu] = fit(meanA(1:4),meanV(1:4),f)

    R = meanR.p1    % resistance in Ohms
    r2 = S.rsquare
    
% errorbar(meanA,meanV,stdV,stdV,stdA,stdA,'.') % 
figure('Units','centimeter',...
       'Position',[10 10 6.5*1.4 6.5],...
       'PaperPositionMode','auto')
   
plot(meanA,meanV,'.',...
    'MarkerSize',8,...
    'color',[0 0 0])
hold on

h = plot(meanR);
    set(h,'color',[0.3 0.3 0.3],'lineWidth',0.5)
    ylabel('Voltage [V]','Interpreter','Latex');
    xlabel('Current [A]','Interpreter','Latex');
    legend('Mean','Linear fit',...
            'Location','NW')
    text(1.5e-3,3,strcat('R = ',num2str(R/1000),' [$k\Omega$]'),...
        'Interpreter','Latex')
    grid on

%% Resistance calculation with polynomial fitting
close all

% taking the average and std variation of data before fitting
meanA = mean([A1,A2,A3,A4,A5],2);
meanV = mean([V1,V2,V3,V4,V5],2);

sorA = sort(meanA)
sorV = sort(meanV)

stdA =std([A1,A2,A3,A4,A5],0,2);
stdV =std([V1,V2,V3,V4,V5],0,2);

% fitting to line and forcing to cross 0x0
f = @(p1,p2,x) p1*x.^2 + p2*x + 0 ;

[meanR,S,mu] = fit(sorA,sorV,f)
%     R = meanR.p1    % resistance in Ohms
%     r2 = S.rsquare
    
% errorbar(meanA,meanV,stdV,stdV,stdA,stdA,'.') % 
figure('Units','centimeter',...
       'Position',[10 10 6.5*1.4 6.5],...
       'PaperPositionMode','auto')
   
plot(sorA,sorV,'.',...
    'MarkerSize',8,...
    'color',[0 0 0])
hold on

h = plot(meanR);
    set(h,'color',[0.3 0.3 0.3],'lineWidth',0.5)
    ylabel('Voltage [V]','Interpreter','Latex');
    xlabel('Current [A]','Interpreter','Latex');
    
dif = differentiate(meanR,sorA); % varying resistivity
dif = dif./1000;

yyaxis right
plot(sorA,dif,'Color', [41/255, 128/255, 185/255])
    ylabel('Resistance [k$\Omega$]','Interpreter','Latex')
    set(gca,'YColor','k')
    legend('Mean','Fit','Resistance', 'Location','Best')
    grid on
    

%% Figures

figure(1)
plot(A1,V1,A2,V2,A3,V3,A4,V4,A5,V5)
legend('Location','SouthEast')
title('Resistencia')
xlabel('Corrente [A]')
ylabel('Tensão [V]')
grid

figure(2)
plot(A1,T1,A2,T2,A3,T3,A4,T4,A5,T5)
legend('Location','SouthEast')
xlabel('Corrente [A]')
ylabel('Temperatura [C]')
grid

figure(3)
plot(V1,T1,V2,T2,V3,T3,V4,T4,V5,T5)
legend('Location','SouthEast')
xlabel('Tensão [V]')
ylabel('Temperatura [C]')
grid

figure(4)
% plot(Amed(1:14),Vmed(1:14))
errorbar(Amed(1:14),Vmed(1:14),Astd(1:14),Vstd(1:14))
xlabel('Corrente [A]')
ylabel('Tensão [V]')
title('Média da Resistência')
hold on
errorbar(Amed(14:27),Vmed(14:27),Astd(14:27),Vstd(14:27))
legend(['Subida'],['Descida'])
grid

figure(5)
errorbar(Vmed(1:14),Tmed(1:14),Vstd(1:14),Tstd(1:14))
ylabel('Temperatura [C]')
xlabel('Tensão [V]')
title('')
hold on
errorbar(Vmed(14:27),Tmed(14:27),Vstd(14:27),Tstd(14:27))
legend(['Subida'],['Descida'])
grid

% hold on
figure(6)
errorbar(Amed(1:14),Tmed(1:14),Astd(1:14),Tstd(1:14))
xlabel('Corrente [A]')
ylabel('Temperatura [C]')
title('')
hold on
errorbar(Amed(14:27),Tmed(14:27),Astd(14:27),Tstd(14:27))
legend(['Subida'],['Descida'])
grid

%% Figure to IEEE paper    - Temperature x Voltage linearity 
belize = [41/256 128/256 185/256];
lightBlack = [0.3 0.3 0.3];
close all
figure('Units','centimeter','Position',[10 10 6.5*1.4 6.5],'PaperPositionMode','auto')
hold on

yyaxis left

errorbar(Vmed(1:14),Tmed(1:14),Vstd(1:14),Tstd(1:14),'-','Color',lightBlack)
errorbar(Vmed(14:27),Tmed(14:27),Vstd(14:27),Tstd(14:27),'-','Color',belize)

xlabel('Voltage [V]','Interpreter','Latex');
ylabel('Temperature [$^\circ$C]','Interpreter','Latex');
set(gca,'YColor','k')
    

convScale = 273.15; 
ax = gca;
celsius = ax.YTick; % ticks from yyaxis left
leftyaxis = celsius + convScale;
leftyaxis = num2str(leftyaxis);%to number
leftyaxis = strsplit(leftyaxis); %converting each string to cell
lim = ax.YLim;

yyaxis right
set(gca,'YColor','k')
% set(gca,'YTickMode','manual')
set(gca,'YLim',lim)
set(gca,'YTickLabel',leftyaxis)
ylabel('Temperature [K]','Interpreter','Latex','Color','k');
legend(['Up'],['Down'],'Location','NorthWest')
box on
grid

%% Linear fit from V =15 to V=25

temperatureRange = find(Vmed > 15 & Vmed < 25);

datay = sort(Tmed(temperatureRange));
datax = sort(Vmed(temperatureRange));

[a,s] = fit( datax, datay, 'poly1');
Rsqr = s.rsquare;

figure('Units','centimeter','Position',[10 10 6.5 5],'PaperPositionMode','auto')
plot(datax,datay,'.-k')
hold on
plot(a)
legend(['$R^2$= ',num2str(Rsqr)], 'Interpreter', 'Latex')

%% Temperature x Voltage linearity with inset

belize = [41/256 128/256 185/256];
lightBlack = [0.3 0.3 0.3];
close all
figure('Units','centimeter','Position',[10 10 6.5*1.4 6.5],...
        'PaperPositionMode','auto')
hold on

yyaxis left

    errorbar(Vmed(1:14),Tmed(1:14),Vstd(1:14),Tstd(1:14),'-',...
        'Color',lightBlack)
    errorbar(Vmed(14:27),Tmed(14:27),Vstd(14:27),Tstd(14:27),'-',...
        'Color',belize)

    xlabel('Voltage [V]','Interpreter','Latex');
    ylabel('Temperature [$^\circ$C]','Interpreter','Latex');
    set(gca,'YColor','k')
    

convScale = 273.15; 
ax = gca;
celsius = ax.YTick; % ticks from yyaxis left
leftyaxis = celsius + convScale;
leftyaxis = num2str(leftyaxis);%to number
leftyaxis = strsplit(leftyaxis); %converting each string to cell
lim = ax.YLim;

yyaxis right
set(gca,'YColor','k')
% set(gca,'YTickMode','manual')
set(gca,'YLim',lim)
set(gca,'YTickLabel',leftyaxis)
ylabel('Temperature [K]','Interpreter','Latex','Color','k');
legend(['Up'],['Down'],'Location','NorthWest')
box on
grid

axes('position',[.55 .210 .25 .25])
box on
plot(datax,datay,'.-k','HandleVisibility','off')
    hold on
    plot(a)
    legend('off')
    % legend(['$R^2$= ',num2str(Rsqr)], 'Interpreter', 'Latex')
    ylabel('')
    xlabel('')
    axis tight
    grid


%% Temperature x Voltage linearity with inset - Sakamoto modification

belize = [41/256 128/256 185/256];
lightBlack = [0.3 0.3 0.3];
close all
fig = figure('Units','centimeter','Position',[10 10 6.5*1.4 6.5],...
        'PaperPositionMode','auto');
hold on

yyaxis left

    errorbar(Vmed(1:14),Tmed(1:14),Vstd(1:14),Tstd(1:14),'-',...
        'Color',lightBlack)
    errorbar(Vmed(14:27),Tmed(14:27),Vstd(14:27),Tstd(14:27),'-',...
        'Color',belize)

    xlabel('Voltage [V]','Interpreter','Latex');
    ylabel('Temperature [$^\circ$C]','Interpreter','Latex');
    set(gca,'YColor','k')
    

convScale = 273.15; 
ax = gca;
celsius = ax.YTick; % ticks from yyaxis left
leftyaxis = celsius + convScale;
leftyaxis = num2str(leftyaxis);%to number
leftyaxis = strsplit(leftyaxis); %converting each string to cell
lim = ax.YLim;

yyaxis right
    set(gca,'YColor','k')
    % set(gca,'YTickMode','manual')
    set(gca,'YLim',lim)
    set(gca,'YTickLabel',leftyaxis)
    ylabel('Temperature [K]','Interpreter','Latex','Color','k');
    legend(['Up'],['Down'],'Location','SouthEast')
    box on
    grid

axes('position',[.200 .550 .30 .35])
box on
plot(datax,datay,'.k','HandleVisibility','off')
    hold on
    plot(a,'k')
    legend('off')
    leg = legend(['$R^2$= ',num2str(Rsqr)], 'Interpreter', 'Latex',...
        'FontSize',6, 'Location', 'NorthWest')
    leg.ItemTokenSize = [10,9]
%     ylabel('')
%     xlabel('')
    xlabel('Voltage [V]','Interpreter','Latex');
    ylabel('Temperature [$^\circ$C]','Interpreter','Latex');
    set(gca,'FontSize',6)
    axis tight
    grid
    
% to fix bug in saveas GUI -- it changes the fontsize otherwise
saveas(fig,'temperature','pdf');
saveas(fig,'temperature','epsc');














































