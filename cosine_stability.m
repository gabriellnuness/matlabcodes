% This script makes a Cosine curve with stability analysis.


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
p1 = plot(t,interf,'-k','LineWidth',1.5);
lin = pi/2 - t;
% p2 = plot(pi/2,offset+cos(pi/2),'ok');
% plot(-pi/2,offset+cos(pi/2),'ok')
% plot(-3*pi/2,offset+cos(pi/2),'ok')
% p4 = plot(t,lin,'--','Color',belize,'linewidth',1.2); 
p3 = plot(deg2rad(60),offset+cos(deg2rad(60)),'.k','MarkerSize',10);
p2 = plot(deg2rad(120),offset+cos(deg2rad(120)),'.k','MarkerSize',10);
p4 = plot(deg2rad(240),offset+cos(deg2rad(240)),'.k','MarkerSize',10);
p5 = plot(deg2rad(300),offset+cos(deg2rad(300)),'.k','MarkerSize',10);
p6 = plot(pi/2,offset+cos(pi/2),'ok','MarkerSize',6);
p7 = plot(3*pi/2,offset+cos(3*pi/2),'xk','MarkerSize',7);
% p4 = plot(t,lin,'r','linewidth',1.5);
%legend([p1 p2 p3],{'Interferometer curve','Quadrature point','Out of quadrature'});
hold off

ylim([-1.2 1.2])
xlim([0 2*pi])
set(gca,'ytick', [-1 0 1] );
set(gca,'yticklabel',{'-AV',0,'AV'})
set(gca,'xtick', pi/2:pi/2:2*pi);
set(gca,'xticklabel',{'$\pi/2$','$\pi$','$3\pi/2$','$2\pi$'})
set(gcf,'Units','centimeter','Position',[0 1 width height])
set(gcf,'PaperPositionMode','auto')
set(gcf,'Renderer','painters')
grid 


