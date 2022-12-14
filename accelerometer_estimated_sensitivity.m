% Sensitivity plot for accelerometers
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')

gr=(1+sqrt(5))/2;
w=7;
size = [w*gr w];
size = [size(1)*2 size(2)]
fontsize = 12;
legendsize = 10;
belize = [41/255 128/255 185/255];
pumpkin = [211/255 84/255 0/255];

%% Arms of interferometer
close all

n = 1.45
m = 22.23*10^-3 % kg
lambda_diode = 1536*10^-9 % m
xi = 0.732
w0 = 2*pi*503.3;
w1 = 0:1:1000;
w = 2*pi.*w1;
G = 60.5 % 1/s
g = 9.80665 % m/s^2


Sens = (2*pi*n*xi/lambda_diode)./(((w0^2 - w.^2).^2 + G^2 * w.^2 ).^(1/2)); %rad/a
Sens = Sens*g; %[rad/g]
plot(w1,Sens)

ylabel('Sensibility [rad/g]','interpreter','latex','fontsize',fontsize)
xlabel('Frequency [Hz]','interpreter','latex','fontsize',fontsize)
box on

%% Fiber laser
C = 0.0043427;
lambda_fiber = 1557.92*10^-9 % m
l = 1*10^-2 % m

Sens2 = (-2*pi*n*l*C/lambda_fiber^2)./(((w0^2 - w.^2).^2 + G^2 * w.^2 ).^(1/2)); %rad/a
Sens2 = Sens2*g;

figure()
plot(w1,Sens2)
ylabel('Sensibility [rad/g]','interpreter','latex','fontsize',fontsize)
xlabel('Frequenct [Hz]','interpreter','latex','fontsize',fontsize)
box on
set(gca,'YDir','reverse')

%%
figure('Units','centimeter','Position',[10 10 size],...
    'PaperPositionMode','auto')
hold on
plot(w1,Sens,'linewidth',1.5,'color',belize)
plot(w1,-Sens2,'linewidth',1.5,'color',pumpkin,'linestyle','-.')
    set(gca, 'YScale', 'log')
    box on
    ylabel('Sensibility [rad/g]','interpreter','latex','fontsize',fontsize)
    xlabel('Frequency [Hz]','interpreter','latex','fontsize',fontsize)
    grid on
    legend('Interferometer arms','Fiber laser',...
        'interpreter','latex','fontsize',legendsize)

%%
% saveas(gcf, 'Sensitivity_estimation.eps', 'epsc2'); 

%%
figure('Units','centimeter','Position',[10 10 size],...
    'PaperPositionMode','auto')
hold on
plot(w1,Sens,'linewidth',1.5,'color',belize)
plot(w1,-Sens2,'linewidth',1.5,'color',pumpkin,'linestyle','-.')
    set(gca, 'YScale', 'log')
    set(gca, 'XScale', 'log')
    box on
    ylabel('Sensibility [rad/g]','interpreter','latex','fontsize',fontsize)
    xlabel('Frequency [Hz]','interpreter','latex','fontsize',fontsize)
    grid on
    legend('Interferometer arms','Fiber laser',...
        'interpreter','latex','fontsize',legendsize,'Location','northwest')

