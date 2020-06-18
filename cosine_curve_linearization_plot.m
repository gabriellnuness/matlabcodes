% This script makes a Cosine curve with a approximation of a Taylor
% linearization line in the quadrature point.


set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
carrot = [255/256 56/256 34/256];
turquesa = [26/256 188/256 156/256];
belize = [41/256 128/256 185/256];
steelblue = [70/256 130/256 180/256];
darkslategray = [47/256 79/256 79/256];
darkgrey = [128/256 128/256 128/256];

% clc
close all
t = -2*pi:0.0001:2*pi;
offset = 0;
interf = offset+(1)*cos(t);
width = 10;
height = 7.5;
figure('Units','centimeter','Position',[0 1 width height],'PaperPositionMode','auto')
xlabel('$\phi$ [rad]','interpreter','latex')
ylabel('v(t) [V]','interpreter','latex')
hold on
p1 = plot(t,interf,'-','Color',darkgrey,'LineWidth',1);
lin = pi/2 - t;
% p2 = plot(pi/2,offset+cos(pi/2),'ok');
% plot(-pi/2,offset+cos(pi/2),'ok')
% plot(-3*pi/2,offset+cos(pi/2),'ok')
p4 = plot(t,lin,'--','Color',belize,'linewidth',1.2); 
p3 = plot(pi/6,offset+cos(pi/6),'.','MarkerSize',15,'Color',carrot);
p2 = plot(pi/2,offset+cos(pi/2),'.k','MarkerSize',15);
lin = pi/2 - t;
% p4 = plot(t,lin,'r','linewidth',1.5);
legend([p1 p4 p2 p3],{'Interferometer curve','Linearization','Quadrature point','Out of quadrature'});
hold off
ylim([-1 1])
xlim([0 2*pi])
set(gca,'xtick', pi/2:pi/2:2*pi);
set(gca,'xticklabel',{'$\pi/2$','$\pi$','$3\pi/2$','$2\pi$'})

grid 


