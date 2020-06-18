close all
clear all
clc
%% Setup the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 2);

% Specify sheet and range
opts.Sheet = "sheet1";
opts.DataRange = "A3:B107";

% Specify column names and types
opts.VariableNames = ["CurrentmA", "PowermW"];
opts.VariableTypes = ["double", "double"];

% Import the data
data = readtable("D:\Users\Stinky\Google Drive\ITA\Data\2 - Laser diode characterization\laser diode characterization - current vs optical power.xlsx", opts, "UseExcel", false);

%% Convert to output type
data = table2array(data);

%% Clear temporary variables
clear opts

current = data(:,1);
power = data(:,2);

width = 10;
height = 7.5;
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
figure('Units','centimeter','Position',[0 1 width height],'PaperPositionMode','auto')

plot(current,power,'k')
grid
xlabel('Current [mA]','Interpreter','latex')
ylabel('Optical Power [mW]','Interpreter','latex')
ylim([-10 330])
axes('position',[.60 .210 .25 .25])
box on
indexOfInterest = (current<=33) & (current>=29);
plot(current(indexOfInterest),power(indexOfInterest),'k')
axis tight
grid

%%

figure('Units','centimeter','Position',[0 11 width height],'PaperPositionMode','auto')

yyaxis left
plot(current,power,'k')
ylabel('Optical Power [mW]','Interpreter','latex')
set(gca,'ycolor','default') 
hold on

yyaxis right
powerDeriv = diff(power);
currentDeriv = diff(current);
firstDeriv = powerDeriv./currentDeriv; %slope
secDeriv = diff(firstDeriv); % threshold
threshold = max(secDeriv)
% plot(current(3:end),secDeriv)

% plot(current(2:end),firstDeriv,':k')
plot(current(2:end),firstDeriv,'Color',[1 1 1]*0.5)
xlabel('Current [mA]','Interpreter','latex')
ylabel('First derivative [W/A]','Interpreter','latex')
set(gca,'ycolor','default') 
legend(['Power'],['Slope'],'Location','SouthEast')
grid

%% This one was used in the mid term report %%%

figure('Units','centimeter','Position',[0 11 width height],'PaperPositionMode','auto')

powerDeriv = diff(power);
currentDeriv = diff(current);
firstDeriv = powerDeriv./currentDeriv; %slope
secDeriv = diff(firstDeriv); % threshold
[val,threshold] = max(secDeriv);
threshold = threshold + 1; %because the derivative does not have the first number

yyaxis left
plot(current,power,'k')
ylabel('Optical Power [mW]','Interpreter','latex')
set(gca,'ycolor','default') 
set(gca,'XTick',sort([threshold,get(gca,'XTick')]));
hold on

yyaxis right
plot(current(2:end),firstDeriv, 'Color',[0.184 0.31 0.31])
xlabel('Current [mA]','Interpreter','latex')
ylabel('First derivative [$\frac{mW}{mA}$]','Interpreter','latex')
set(gca,'ycolor','default') 
legend(['Power'],['Slope'],'Location','Best')
grid

axes('position',[.60 .210 .25 .25])
box on
indexOfInterest = (current<=33) & (current>=29);
plot(current(indexOfInterest),power(indexOfInterest),'k')
axis tight
grid

%% This one is the update version of the one used in the midterm report %%%
close all
figure('Units','centimeter','Position',[10 11 width height],'PaperPositionMode','auto')

powerDeriv = diff(power);
currentDeriv = diff(current);
firstDeriv = powerDeriv./currentDeriv; %slope
secDeriv = diff(firstDeriv); % threshold
[val,threshold] = max(secDeriv);
threshold = threshold + 1; %because the derivative does not have the first number

yyaxis left
plot(current,power,'k')
ylabel('Optical Power [mW]','Interpreter','latex')
set(gca,'ycolor','default') 
set(gca,'XTick',sort([threshold,get(gca,'XTick')]));
hold on

yyaxis right
plot(current(2:end),firstDeriv,'-.','LineWidth',0.5, 'Color',[1 1 1]*0.5)
xlabel('Current [mA]','Interpreter','latex')
ylabel('First derivative [$\frac{mW}{mA}$]','Interpreter','latex')
set(gca,'ycolor','default') 
legend(['Optical Power'],['First derivative'],'Location','Best')
grid

axes('position',[.60 .210 .25 .25])
box on
indexOfInterest = (current<=33) & (current>=29);
plot(current(indexOfInterest),power(indexOfInterest),'k')
axis tight
grid


