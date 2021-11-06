% this scripts generates an unforced mass-spring-damper system


set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
clear all
close all
clc
belize = [41/255 128/255 185/255];

gamma = 10; % damping factor
f0 = 20;
w0 = 2*pi*f0;
x0  = 1;
t = 0:0.001:10/f0;

x = x0.*exp(-gamma/2 .* t).*exp(1i*w0.*t);
decay = x0.*exp(-gamma/2 .* t);

figure('Units','centimeter','Position',[0 1 8 5],...
       'PaperPositionMode','auto')
hold on
plot(t,x,'color',[.3 .3 .3])
plot(t,decay,'color',belize)
legend('$x(t)$','$e^{-\frac{\Gamma}{2}t}$','interpreter','latex',...
    'fontsize',12)
set(gca,'XTick',[],'YTick',[])
xlabel('Time','interpreter','latex','fontsize',12)
ylabel('a.u.','interpreter','latex','fontsize',12)
box on
