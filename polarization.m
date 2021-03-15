% This script is trying to simulate the Michelson interferometer
% with the Faraday Rotator mirror and its effect by using the Poincaré
% sphere visualization with Jones matrices for the optical elements in 
% the system.
clear 
close all
clc

% Jones matrices
laser = [1;1] % 
DC = 1/2 % Just divide by half 
         % considering the same retardation on bothsides, if it does have.   
M = [-1 0 ; 0 1]    % Mirror model

theta = -pi/4; % rotate 45 deg towards x
FR = [cos(theta) sin(theta); -sin(theta) cos(theta)] %rotator matrix
FR_b = FR'

%retarder sensor arm
% if there is no retardation (1 0 ; 0 1)
delta = 1.3*pi; % retardation pi/4
phi = -pi/3; % rotation from x axis pi/4    %nice change from [1 1] is 1.3*pi,-pi/3
% forward generic retarder and rotation
Rs_f = [cos(phi)^2*exp(1i*delta/2)+sin(phi)^2*exp(-1i*delta/2)    1i*sin(2*phi)*sin(delta/2);
     1i*sin(2*phi)*sin(delta/2)   sin(phi)^2*exp(1i*delta/2)+cos(phi)^2*exp(-1i*delta/2)] 
% backward generic retarder and rotation
Rs_b = [cos(phi)^2*exp(1i*delta/2)+sin(phi)^2*exp(-1i*delta/2)    -1i*sin(2*phi)*sin(delta/2);
     -1i*sin(2*phi)*sin(delta/2)   sin(phi)^2*exp(1i*delta/2)+cos(phi)^2*exp(-1i*delta/2)]  

 %retarder reference arm
delta = +1.3*pi;   % retardation pi/5
phi = pi/26; % rotation from x axis pi/3; pi/4.5
% forward generic retarder and rotation
Rr_f = [cos(phi)^2*exp(1i*delta/2)+sin(phi)^2*exp(-1i*delta/2)    1i*sin(2*phi)*sin(delta/2);
     1i*sin(2*phi)*sin(delta/2)   sin(phi)^2*exp(1i*delta/2)+cos(phi)^2*exp(-1i*delta/2)] 
% backward generic retarder and rotation
Rr_b = [cos(phi)^2*exp(1i*delta/2)+sin(phi)^2*exp(-1i*delta/2)    -1i*sin(2*phi)*sin(delta/2);
     -1i*sin(2*phi)*sin(delta/2)   sin(phi)^2*exp(1i*delta/2)+cos(phi)^2*exp(-1i*delta/2)]  

%% Points to plot
% begin at the end
s0 = stokes(laser);

% sensor arm
s1 = stokes(Rs_f*laser);
s2 = stokes(FR*Rs_f*laser);
s3 = stokes(M*FR*Rs_f*laser);
s4 = stokes(FR_b*M*FR*Rs_f*laser);
s5 = stokes(Rs_b*FR_b*M*FR*Rs_f*laser); %recombine point

s6 = stokes(Rr_f*laser);
s7 = stokes(FR*Rr_f*laser);
s8 = stokes(M*FR*Rr_f*laser);
s9 = stokes(FR_b*M*FR*Rr_f*laser);
s10 = stokes(Rr_b*FR_b*M*FR*Rr_f*laser); %recombine point

%%%%%%%%%%% choose the one point to plot
s = s0;
%%%%%%%%%%%

%normalize
s = 1/s(1) * s;
%% With the Faraday Rotator Mirror Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
clear y_pm x_pm z_pm_p z_pm_n
clear x_e z_e y_e_p y_e_n r
clear z_m y_m x_m_p x_m_n
clear X Y Z x y z
clear Hs Hx Hy Hz
clear He Hpm H
% plot data
fig = figure('Units','Centimeter','Position',[10 1 20 20]);

r = s(1);
[X,Y,Z] = sphere(20);
x0 = 0; y0 = 0; z0 = 0; %center
X = X*r + x0;
Y = Y*r + y0;
Z = Z*r + z0;

Hs = mesh(X,Y,Z,...
    'facecolor', 0.95*[1 1 1],...
    'FaceAlpha', 0.3,...%0.7 default
    'edgecolor', 0.6*[1 1 1],...
    'edgeAlpha',0.7);  % set grid facecolor to white

caxis([1.0 1.01]);  % set grid to appear like all one color
axis equal;  % make the three axes equal so the ellipsoid looks like a sphere
hold on;

% Draw x- and y- and z-axes
Hx = plot3([-r*1.5 r*1.5], [0 0], [0 0],'k-');
    set(Hx,'linewidth',1,'linestyle','-','color','k');
    text(r*1.85,0,0,'$+S_1$',...
        'Interpreter','latex');

Hy = plot3([0 0], [-r*1.5 r*1.5], [0 0],'k-');
    set(Hy,'linewidth',1,'linestyle','-','color','k');
    text(0.1,r*1.65,0,'$+S_2$',...
    'Interpreter','latex');

Hz = plot3([0 0], [0 0], [-r*1.5 r*1.5],'k-');
    set(Hz,'linewidth',1,'linestyle','-','color','k');
    text(-r*0.05,0,r*1.55,'$+S_3$',...
        'Interpreter','latex');

text(-r*0.05,0.0,r*1.2,'RC',...
    'interpreter','latex','color','k');

text(-r*0.05,0.0,-r*1.3,'LC',...
    'interpreter','latex','color','k');

text(-r*0.05,0,r*1.55,'$+S_3$',...
    'Interpreter','latex');

text(+r*1.2,0,0.2,'$H$',...
    'Interpreter','latex');

text(-1.2*r,0,0.05,'$V$',...
    'Interpreter','latex');

% Draw a bold circle about the equator (2*epsilon = 0)
r = r*1.005;
x_e = (-r:.01:r);
for i = 1:length(x_e)
z_e(i) = 0;
y_e_p(i) = +sqrt(r^2 - x_e(i)^2);
y_e_n(i) = -sqrt(r^2 - x_e(i)^2);
end
He = plot3(x_e,y_e_p,z_e,'k-',x_e,y_e_n,z_e,'k-');
set(He,'linewidth',0.7,'color','k');
% Draw a bold circle about the prime meridian (2*theta = 0, 180)

y_pm = (-r:.01:r);
for i = 1:length(y_pm)
x_pm(i) = 0;
z_pm_p(i) = +sqrt(r^2 - y_pm(i)^2);
z_pm_n(i) = -sqrt(r^2 - y_pm(i)^2);
end
Hpm = plot3(x_pm,y_pm,z_pm_p,'k-',x_pm,y_pm,z_pm_n,'k-');
set(Hpm,'linewidth',0.7,'color','k');

z_m = (-r:.01:r);
for i = 1:length(z_m)
y_m(i) = 0;
x_m_p(i) = +sqrt(r^2 - z_m(i)^2);
x_m_n(i) = -sqrt(r^2 - z_m(i)^2);
end
Hpm = plot3(x_m_p,y_m,z_m,'k-',x_m_n,y_m,z_m,'k-');
set(Hpm,'linewidth',0.7,'color','k');
view(135,20);  %135,20

set(gcf,'Renderer','Painters');


%%
belize = [41/256 128/256 185/256];
pomegranate = [192/256 57/256 43/256];
chosen_color = belize;

set(gca,'visible','off') % remove axis
set(gcf,'Renderer','Painters');


% saveas(fig,'poincare_wbg','pdf');
% saveas(fig,'poincare_wbg','epsc');
 
%% draw all points 

s = s0  ;    %laser
s = 1/s(1) * s

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.05,y*1.1,z*1+0.15,'$P_0$','Interpreter','latex','fontsize',12);


%% 
s = s1 ;    %laser + Rs
s = 1/s(1) * s

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.15,y*1.1,z*1+0.15,'$P_1$','Interpreter','latex','fontsize',12);

%% 
s = s2 ;    %laser + Rs +FR
s = 1/s(1) * s

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.05,y*1.1,z*1-0.1,'$P_2$','Interpreter','latex','fontsize',12);

%% 
s = s3;     %laser + Rs +FR +M
s = 1/s(1) * s

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.05,y*1.1,z*1-0.15,'$P_3$','Interpreter','latex','fontsize',12);

%% 
s = s4;     %laser + Rs +FR +M +FR'
s = 1/s(1) * s

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.05,y*1.1,z*1+0.15,'$P_4$','Interpreter','latex','fontsize',12);

%% 
s = s5  ;   %laser + Rs +FR +M +FR' +Rs'
s = 1/s(1) * s;

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.35,y*1.1,z*1+0.2,'$P_5$','Interpreter','latex','fontsize',12);

saveas(fig,'sensor_arm_FRM','pdf');
saveas(fig,'sensor_arm_FRM','epsc');
    
%% Reference Arm    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear y_pm x_pm z_pm_p z_pm_n
clear x_e z_e y_e_p y_e_n r
clear z_m y_m x_m_p x_m_n
clear X Y Z x y z
clear Hs Hx Hy Hz
clear He Hpm H
% plot data
fig = figure('Units','Centimeter','Position',[10 1 20 20]);

r = s(1);
[X,Y,Z] = sphere(20);
x0 = 0; y0 = 0; z0 = 0; %center
X = X*r + x0;
Y = Y*r + y0;
Z = Z*r + z0;

Hs = mesh(X,Y,Z,...
    'facecolor', 0.95*[1 1 1],...
    'FaceAlpha', 0.3,...%0.7 default
    'edgecolor', 0.6*[1 1 1],...
    'edgeAlpha',0.7);  % set grid facecolor to white

caxis([1.0 1.01]);  % set grid to appear like all one color
axis equal;  % make the three axes equal so the ellipsoid looks like a sphere
hold on;

% Draw x- and y- and z-axes
Hx = plot3([-r*1.5 r*1.5], [0 0], [0 0],'k-');
    set(Hx,'linewidth',1,'linestyle','-','color','k');
    text(r*1.85,0,0,'$+S_1$',...
        'Interpreter','latex');

Hy = plot3([0 0], [-r*1.5 r*1.5], [0 0],'k-');
    set(Hy,'linewidth',1,'linestyle','-','color','k');
    text(0.1,r*1.65,0,'$+S_2$',...
    'Interpreter','latex');

Hz = plot3([0 0], [0 0], [-r*1.5 r*1.5],'k-');
    set(Hz,'linewidth',1,'linestyle','-','color','k');
    text(-r*0.05,0,r*1.55,'$+S_3$',...
        'Interpreter','latex');

text(-r*0.05,0.0,r*1.2,'RC',...
    'interpreter','latex','color','k');

text(-r*0.05,0.0,-r*1.3,'LC',...
    'interpreter','latex','color','k');

text(-r*0.05,0,r*1.55,'$+S_3$',...
    'Interpreter','latex');

text(+r*1.2,0,0.2,'$H$',...
    'Interpreter','latex');

text(-1.2*r,0,0.05,'$V$',...
    'Interpreter','latex');

% Draw a bold circle about the equator (2*epsilon = 0)
r = r*1.005;
x_e = (-r:.01:r);
for i = 1:length(x_e)
z_e(i) = 0;
y_e_p(i) = +sqrt(r^2 - x_e(i)^2);
y_e_n(i) = -sqrt(r^2 - x_e(i)^2);
end
He = plot3(x_e,y_e_p,z_e,'k-',x_e,y_e_n,z_e,'k-');
set(He,'linewidth',0.7,'color','k');
% Draw a bold circle about the prime meridian (2*theta = 0, 180)

y_pm = (-r:.01:r);
for i = 1:length(y_pm)
x_pm(i) = 0;
z_pm_p(i) = +sqrt(r^2 - y_pm(i)^2);
z_pm_n(i) = -sqrt(r^2 - y_pm(i)^2);
end
Hpm = plot3(x_pm,y_pm,z_pm_p,'k-',x_pm,y_pm,z_pm_n,'k-');
set(Hpm,'linewidth',0.7,'color','k');

z_m = (-r:.01:r);
for i = 1:length(z_m)
y_m(i) = 0;
x_m_p(i) = +sqrt(r^2 - z_m(i)^2);
x_m_n(i) = -sqrt(r^2 - z_m(i)^2);
end
Hpm = plot3(x_m_p,y_m,z_m,'k-',x_m_n,y_m,z_m,'k-');
set(Hpm,'linewidth',0.7,'color','k');
view(135,20);  %135,20

set(gcf,'Renderer','Painters');
    
%% draw all points 

s = s0  ;    %laser
s = 1/s(1) * s;

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.05,y*1.1,z*1+0.15,'$P_0$','Interpreter','latex','fontsize',12);


%% 
s = s6 ;    %laser + Rr
s = 1/s(1) * s;

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.15,y*1.1,z*1+0.15,'$P_1$','Interpreter','latex','fontsize',12);

%% 
s = s7 ;    %laser + Rr +FR
s = 1/s(1) * s;

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.15,y+0.1,z*1-0.1,'$P_2$','Interpreter','latex','fontsize',12);

%% 
s = s8;     %laser + Rr +FR +M
s = 1/s(1) * s;

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.05,y*1.1,z*1-0.15,'$P_3$','Interpreter','latex','fontsize',12);

%% 
s = s9;     %laser + Rr +FR +M +FR'
s = 1/s(1) * s;

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.05,y*1.1,z*1+0.15,'$P_4$','Interpreter','latex','fontsize',12);

%% 
s = s10;     %laser + Rr +FR +M +FR' +Rr'
s = 1/s(1) * s;

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.35,y*1.1,z*1+0.2,'$P_5$','Interpreter','latex','fontsize',12);

    
saveas(fig,'reference_arm_FRM','pdf');
saveas(fig,'reference_arm_FRM','epsc');    
    
%% Without the Faraday Rotator Mirror Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% sensor arm
s1 = stokes(Rs_f*laser);
s2 = stokes(M*Rs_f*laser);
s3 = stokes(Rs_b*M*Rs_f*laser); %recombine point

s4 = stokes(Rr_f*laser);
s5 = stokes(M*Rr_f*laser);
s6 = stokes(Rr_b*M*Rr_f*laser); %recombine point

%%%%%%%%%%% choose the one point to plot
s = s0;
%%%%%%%%%%%

%normalize
s = 1/s(1) * s;
%% sphere from matlab script
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')
clear y_pm x_pm z_pm_p z_pm_n
clear x_e z_e y_e_p y_e_n r
clear z_m y_m x_m_p x_m_n
clear X Y Z x y z
clear Hs Hx Hy Hz
clear He Hpm H
% plot data
fig = figure('Units','Centimeter','Position',[10 1 20 20]);

r = s(1);
[X,Y,Z] = sphere(20);
x0 = 0; y0 = 0; z0 = 0; %center
X = X*r + x0;
Y = Y*r + y0;
Z = Z*r + z0;

Hs = mesh(X,Y,Z,...
    'facecolor', 0.95*[1 1 1],...
    'FaceAlpha', 0.3,...%0.7 default
    'edgecolor', 0.6*[1 1 1],...
    'edgeAlpha',0.7);  % set grid facecolor to white

caxis([1.0 1.01]);  % set grid to appear like all one color
axis equal;  % make the three axes equal so the ellipsoid looks like a sphere
hold on;

% Draw x- and y- and z-axes
Hx = plot3([-r*1.5 r*1.5], [0 0], [0 0],'k-');
    set(Hx,'linewidth',1,'linestyle','-','color','k');
    text(r*1.85,0,0,'$+S_1$',...
        'Interpreter','latex');

Hy = plot3([0 0], [-r*1.5 r*1.5], [0 0],'k-');
    set(Hy,'linewidth',1,'linestyle','-','color','k');
    text(0.1,r*1.65,0,'$+S_2$',...
    'Interpreter','latex');

Hz = plot3([0 0], [0 0], [-r*1.5 r*1.5],'k-');
    set(Hz,'linewidth',1,'linestyle','-','color','k');
    text(-r*0.05,0,r*1.55,'$+S_3$',...
        'Interpreter','latex');

text(-r*0.05,0.0,r*1.2,'RC',...
    'interpreter','latex','color','k');

text(-r*0.05,0.0,-r*1.3,'LC',...
    'interpreter','latex','color','k');

text(-r*0.05,0,r*1.55,'$+S_3$',...
    'Interpreter','latex');

text(+r*1.2,0,0.2,'$H$',...
    'Interpreter','latex');

text(-1.2*r,0,0.05,'$V$',...
    'Interpreter','latex');

% Draw a bold circle about the equator (2*epsilon = 0)
r = r*1.005;
x_e = (-r:.01:r);
for i = 1:length(x_e)
z_e(i) = 0;
y_e_p(i) = +sqrt(r^2 - x_e(i)^2);
y_e_n(i) = -sqrt(r^2 - x_e(i)^2);
end
He = plot3(x_e,y_e_p,z_e,'k-',x_e,y_e_n,z_e,'k-');
set(He,'linewidth',0.7,'color','k');
% Draw a bold circle about the prime meridian (2*theta = 0, 180)

y_pm = (-r:.01:r);
for i = 1:length(y_pm)
x_pm(i) = 0;
z_pm_p(i) = +sqrt(r^2 - y_pm(i)^2);
z_pm_n(i) = -sqrt(r^2 - y_pm(i)^2);
end
Hpm = plot3(x_pm,y_pm,z_pm_p,'k-',x_pm,y_pm,z_pm_n,'k-');
set(Hpm,'linewidth',0.7,'color','k');

z_m = (-r:.01:r);
for i = 1:length(z_m)
y_m(i) = 0;
x_m_p(i) = +sqrt(r^2 - z_m(i)^2);
x_m_n(i) = -sqrt(r^2 - z_m(i)^2);
end
Hpm = plot3(x_m_p,y_m,z_m,'k-',x_m_n,y_m,z_m,'k-');
set(Hpm,'linewidth',0.7,'color','k');
view(135,20);  %135,20

set(gcf,'Renderer','Painters');


%%
belize = [41/256 128/256 185/256];
pomegranate = [192/256 57/256 43/256];
chosen_color = belize;

set(gca,'visible','off') % remove axis
set(gcf,'Renderer','Painters');


% saveas(fig,'poincare_wbg','pdf');
% saveas(fig,'poincare_wbg','epsc');
 
%% draw all points 

s = s0  ;    %laser
s = 1/s(1) * s

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.05,y*1.1,z*1+0.15,'$P_0$','Interpreter','latex','fontsize',12);


%% 
s = s1 ;    %laser + Rs
s = 1/s(1) * s

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.15,y*1.1,z*1+0.15,'$P_1$','Interpreter','latex','fontsize',12);

%% 
s = s2 ;    %laser + Rs +M
s = 1/s(1) * s

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.05,y*1.1,z*1-0.1,'$P_2$','Interpreter','latex','fontsize',12);

%% 
s = s3;     %laser + Rs +M +Rs'
s = 1/s(1) * s

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.05,y*1.1,z*1-0.15,'$P_3$','Interpreter','latex','fontsize',12);

saveas(fig,'sensor_arm_M','pdf');
saveas(fig,'sensor_arm_M','epsc');
    
%% Reference Arm    

clear y_pm x_pm z_pm_p z_pm_n
clear x_e z_e y_e_p y_e_n r
clear z_m y_m x_m_p x_m_n
clear X Y Z x y z
clear Hs Hx Hy Hz
clear He Hpm H
% plot data
fig = figure('Units','Centimeter','Position',[10 1 20 20]);

r = s(1);
[X,Y,Z] = sphere(20);
x0 = 0; y0 = 0; z0 = 0; %center
X = X*r + x0;
Y = Y*r + y0;
Z = Z*r + z0;

Hs = mesh(X,Y,Z,...
    'facecolor', 0.95*[1 1 1],...
    'FaceAlpha', 0.3,...%0.7 default
    'edgecolor', 0.6*[1 1 1],...
    'edgeAlpha',0.7);  % set grid facecolor to white

caxis([1.0 1.01]);  % set grid to appear like all one color
axis equal;  % make the three axes equal so the ellipsoid looks like a sphere
hold on;

% Draw x- and y- and z-axes
Hx = plot3([-r*1.5 r*1.5], [0 0], [0 0],'k-');
    set(Hx,'linewidth',1,'linestyle','-','color','k');
    text(r*1.85,0,0,'$+S_1$',...
        'Interpreter','latex');

Hy = plot3([0 0], [-r*1.5 r*1.5], [0 0],'k-');
    set(Hy,'linewidth',1,'linestyle','-','color','k');
    text(0.1,r*1.65,0,'$+S_2$',...
    'Interpreter','latex');

Hz = plot3([0 0], [0 0], [-r*1.5 r*1.5],'k-');
    set(Hz,'linewidth',1,'linestyle','-','color','k');
    text(-r*0.05,0,r*1.55,'$+S_3$',...
        'Interpreter','latex');

text(-r*0.05,0.0,r*1.2,'RC',...
    'interpreter','latex','color','k');

text(-r*0.05,0.0,-r*1.3,'LC',...
    'interpreter','latex','color','k');

text(-r*0.05,0,r*1.55,'$+S_3$',...
    'Interpreter','latex');

text(+r*1.2,0,0.2,'$H$',...
    'Interpreter','latex');

text(-1.2*r,0,0.05,'$V$',...
    'Interpreter','latex');

% Draw a bold circle about the equator (2*epsilon = 0)
r = r*1.005;
x_e = (-r:.01:r);
for i = 1:length(x_e)
z_e(i) = 0;
y_e_p(i) = +sqrt(r^2 - x_e(i)^2);
y_e_n(i) = -sqrt(r^2 - x_e(i)^2);
end
He = plot3(x_e,y_e_p,z_e,'k-',x_e,y_e_n,z_e,'k-');
set(He,'linewidth',0.7,'color','k');
% Draw a bold circle about the prime meridian (2*theta = 0, 180)

y_pm = (-r:.01:r);
for i = 1:length(y_pm)
x_pm(i) = 0;
z_pm_p(i) = +sqrt(r^2 - y_pm(i)^2);
z_pm_n(i) = -sqrt(r^2 - y_pm(i)^2);
end
Hpm = plot3(x_pm,y_pm,z_pm_p,'k-',x_pm,y_pm,z_pm_n,'k-');
set(Hpm,'linewidth',0.7,'color','k');

z_m = (-r:.01:r);
for i = 1:length(z_m)
y_m(i) = 0;
x_m_p(i) = +sqrt(r^2 - z_m(i)^2);
x_m_n(i) = -sqrt(r^2 - z_m(i)^2);
end
Hpm = plot3(x_m_p,y_m,z_m,'k-',x_m_n,y_m,z_m,'k-');
set(Hpm,'linewidth',0.7,'color','k');
view(135,20);  %135,20

set(gcf,'Renderer','Painters');
    
%% draw all points 

s = s0  ;    %laser
s = 1/s(1) * s;

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.05,y*1.1,z*1+0.15,'$P_0$','Interpreter','latex','fontsize',12);


%% 
s = s4;     %laser + Rr
s = 1/s(1) * s

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.05,y*1.1,z*1+0.15,'$P_1$','Interpreter','latex','fontsize',12);

%% 
s = s5  ;   %laser + Rr + M
s = 1/s(1) * s;

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.35,y*1.1,z*1+0.2,'$P_2$','Interpreter','latex','fontsize',12);


    %% 
s = s6  ;   %laser + Rr + M +Rr'
s = 1/s(1) * s;

x = s(2);
y = s(3);
z = s(4);

% Now plot the polarimetry data
plot3(x*1.005,y*1.005,z*1.005,'.','markersize',25, 'color', chosen_color);
    text(x*1+0.35,y*1.1,z*1+0.2,'$P_3$','Interpreter','latex','fontsize',12);

saveas(fig,'reference_arm_M','pdf');
saveas(fig,'reference_arm_M','epsc');

    %% signal plot
% 
% % p = polratio(s);    %polarization ratio \gamma
% 
% % polarization helper viewer check
% figure
% helperPolarizationView(p4)
% 
% %% Ellipse drawing
% 
% % elliptical model
%     % how can I draw the ellipse with a1 and a2?
% figure
% polellip(p1) %gives the ellipse characteristics and plot
% 
% [tau,epsilon,ar,rs] = polellip(p1); % ar = a1/a2




