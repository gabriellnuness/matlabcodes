% Importing the data file:
addpath('C:\Users\User\Desktop\Allan IFOG 1310 nm')

file = 'GiroData_Final_de_semana_2305_SUTEC.txt';
tic
omega = readmatrix(file);
toc
%%
omega = omega(5e6:15e6,1);

fs = 100;                       % Sample rate
% t_gyro = linspace(0,(length(omega)-1)/fs,length(omega));

pts = 1e3; 
m_max = (length(omega)-1)/2;
m_max = 2.^(floor(log2(m_max)));
m = logspace(0, log10(m_max), pts)';
m = ceil(m);
m = unique(m);

tic
[avar_gyro_2, taus_gyro_2] = allanvar(omega,m,fs);
toc

figure
loglog(taus_gyro_2, sqrt(avar_gyro_2))
    title('Gyroscope Allan deviation - MATLAB')
    xlabel('$\tau(m)$','interpreter','latex')
    ylabel('$\sigma(\tau)$','interpreter','latex')
