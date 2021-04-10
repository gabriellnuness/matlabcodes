% This script makes a Cosine curve with a approximation of a Taylor
% linearization line in the quadrature point.
clc
close all
clear all

set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
carrot = [255/256 56/256 34/256];
turquesa = [26/256 188/256 156/256];
belize = [41/256 128/256 185/256];
steelblue = [70/256 130/256 180/256];
darkslategray = [47/256 79/256 79/256];
darkgrey = [128/256 128/256 128/256];

gratio = (1+sqrt(5))/2;

width = 12; %12 for one figure, 10 for 2.
height = width/gratio;
axes_fontsize = 10;
legend_fontsize = 8;


t = -2*pi:0.0001:2*pi;
offset = 0;
interf = offset+(1)*cos(t);
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
legend([p1 p4 p2 p3],...
    {'Interferometric curve','Linearization',...
    'Quadrature point','Out of quadrature'},...
    'FontSize',legend_fontsize, 'location', 'north');
hold off
ylim([-1 1])
xlim([0 2*pi])
set(gca,'xtick', pi/2:pi/2:2*pi);
set(gca,'xticklabel',{'$\pi/2$','$\pi$','$3\pi/2$','$2\pi$'})
set(gca,'fontsize',axes_fontsize)
set(gca,'box','on')
grid 


save_folder = 'D:\Users\Stinky\Google Drive\ITA\Dissertation\1 - Dissertation\Cap2'
cd(save_folder)
print(gcf,'quadrature3.eps','-depsc')
print(gcf,'quadrature3.pdf','-dpdf')
