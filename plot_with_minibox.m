close all

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
hold on

yyaxis right
powerDeriv = diff(power);
currentDeriv = diff(current);
firstDeriv = powerDeriv./currentDeriv
plot(current(2:end),firstDeriv,'Color',[])

% figure('Units','centimeter','Position',[10 11 width height],'PaperPositionMode','auto')
% plot(der2)






