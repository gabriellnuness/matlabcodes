% This script makes a plot showing differente kinds of modulation possible
% in a cosine curve, out of quadrature, and in quadrature and with
% different amplitudes

clear all
clc
close all
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');

%Definção de cores
carrot = [230/256 126/256 34/256];
turquesa = [26/256 188/256 156/256];
belize = [41/256 128/256 185/256];
steelblue = [70/256 130/256 180/256];
%definição de periodo unitario como base para o feixe do laser.
T = 2*pi;
t = -T:0.0001:4*T;
f = 1/T;
w = 2*pi*f;
A = 1;
x1 = cos(w*t);

%onda de perturbação em quadratura
Ty = T/4;
fy = 1/Ty;
wy = 2*pi*fy;
Ay = pi/4; %amplitude da perturbacao
y = Ay*cos(wy*t)+pi/2;

x = A*cos(y);

width=14;
height=14;
figure('Units','centimeter','Position',[10 10 width height],'PaperPositionMode','auto')

hold all
subplot(3,2,1)
plot(t,x1,'Color','k');
hold on
plot(y,t,'-.','Color',steelblue,'LineWidth',1.0)
set(gca,'FontName','LaTex');
set(gca,'ytick',[min(x1),max(x1)]);
set(gca,'xtick',-pi/2:pi:4*pi);
set(gca,'xticklabel',{'$-\pi/2$','$\pi/2$','$3\pi/2$','$5\pi/2$','$7\pi/2$'})
title('(a)','interpreter','latex')
ylabel('I','interpreter','latex')
xlabel('$\phi$')


grid
axis([-pi 4*pi -2 2])
subplot(3,2,2)
plot(t,x,'Color', 'k')
set(gca,'FontName','latex');
set(gca,'ytick',[round(min(x),1),round(max(x),1)]);
set(gca,'xtick',[]);
xlabel('time [s]','interpreter','latex')
ylabel('I(t)','interpreter','latex')
grid
axis([-pi 4*pi -2 2])
title('(b)','interpreter','latex')

%onda de perturbação no ponto de minimo sinal
y = Ay*cos(wy*t)+pi;

x = A*cos(y);

subplot(3,2,3)
plot(t,x1,'Color','k');
hold on
plot(y,t,'-.','Color',belize,'LineWidth',1.0)
set(gca,'FontName','latex');
set(gca,'ytick',[min(x1),max(x1)]);
set(gca,'xtick',-pi/2:pi:4*pi);
set(gca,'xticklabel',{'$-\pi/2$','$\pi/2$','$3\pi/2$','$5\pi/2$','$7\pi/2$'})
title({'','(c)'},'interpreter','latex')
ylabel('I','interpreter','latex')
xlabel('$\phi$')
grid
axis([-pi 4*pi -2 2])
subplot(3,2,4)
plot(t,x,'Color', 'k')
set(gca,'FontName','latex');
set(gca,'ytick',[round(min(x),1),round(max(x),1)]);
set(gca,'xtick',[]);
xlabel('time [s]','interpreter','latex')
ylabel('I(t)','interpreter','latex')
axis([-pi 4*pi -1.5 0])
grid on
title({'','(d)'},'interpreter','latex')

%onda de perturbação no ponto de quadratura mas com Ay grande
Ay = pi;
y = Ay*cos(wy*t)+pi/2;

x = A*cos(y);

subplot(3,2,5)
plot(t,x1,'Color','k');
hold on
plot(y,t,'-.','Color',belize,'LineWidth',1.0)
set(gca,'FontName','latex');
set(gca,'ytick',[min(x1),max(x1)]);
set(gca,'xtick',-pi/2:pi:4*pi);
set(gca,'xticklabel',{'$-\pi/2$','$\pi/2$','$3\pi/2$','$5\pi/2$','$7\pi/2$'})
title({'','(e)'},'interpreter','latex')
ylabel('I','interpreter','latex')
xlabel('$\phi$')
grid
axis([-pi 4*pi -2 2])
subplot(3,2,6)
plot(t,x,'Color', 'k')
set(gca,'FontName','latex');
set(gca,'ytick',[round(min(x),1),round(max(x),1)]);
set(gca,'xtick',[]);
xlabel('time [s]','interpreter','latex')
ylabel('I(t)','interpreter','latex')
axis([-pi 4*pi -2 2])
grid on
title({'','(f)'},'interpreter','latex')
