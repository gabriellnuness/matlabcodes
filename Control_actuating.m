set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
time = newd(:,1)+5;
signal = newd(:,3);
response = newd(:,4);
control = newd(:,2);
close all
figure('Units','centimeter','Position',[0 1 20 5],'PaperPositionMode','auto')
xc = 0.3;

subplot(2,1,1)
plot(time,signal,'Color',[xc,xc,xc])
ylim([1.2*min(signal) 1.2*max(signal)])
legend('Input electrical signal', 'FontSize', 10)
xlabel('Seconds','Interpreter','latex', 'FontSize', 10)
ylabel('Volts','Interpreter','latex', 'FontSize', 10)

subplot(2,1,2)
plot(time,response,'Color',[xc,xc,xc])
ylim([-1.2*min(response) 1.2*max(response)])
legend('Interferometric signal', 'FontSize', 10)
xlabel('Seconds','Interpreter','latex', 'FontSize', 10)
ylabel('Volts','Interpreter','latex', 'FontSize', 10)