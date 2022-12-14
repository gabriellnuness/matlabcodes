clc
clear

earth_ang_vel =  7.2921151467e-5; % rad/s
earth_ang_vel = rad2deg(earth_ang_vel); % deg/s
earth_ang_vel = earth_ang_vel*3600; % deg/h

w_ie = [0 0 earth_ang_vel]'; % ECEF
% w_ie = [1 1 1]'; % ECEF

% Sao Jose dos Campos
lat = deg2rad(-23.251432); % degrees
lon = deg2rad(-45.855916); % degrees
h = 600;          % meters

R1 = [ cos(lon)  sin(lon) 0
      -sin(lon)  cos(lon) 0
       0         0        1];

x = (lat + pi/2);
R2 = [ cos(x)   0       sin(x) 
       0        1       0 
      -sin(x)   0       cos(x)];

NED = R2*R1*[w_ie]