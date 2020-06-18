% This program collects all the spectrum data in the folder in one 3D array
% and plots all the spectrums.
clear all
close all
clc
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')

dir = uigetdir('D:\Users\Stinky\Google Drive\ITA\Data\1 - Fiber laser measurements');
addpath(dir)
extension = '.lvm';

N = input('Qual o numero do ultimo arquivo na pasta?   R:');

% tempData = importdata('LabVIEW Data 0 .lvm');
tempData = lvm_import('LabVIEW Data 0 .lvm',0);
y = tempData.Segment1.data(:,1); %dBm
x = tempData.Segment1.data(:,2); %mx
current = tempData.Segment1.data(1,3); %mA
% 
% x=[x0;x1];
% y=[y0;y1];
% current = [current0;current1];

z = ones(length(x),1);
tempMatrix = zeros(0,N);
% figure
% hold on
for i=1:N+1
file = ['LabVIEW Data',' ',num2str(i-1),' ',extension];
% tempData = importdata(file);
tempData = lvm_import(file,0);
y = tempData.Segment1.data(:,1); %dBm
x = tempData.Segment1.data(:,2); %m
current = tempData.Segment1.data(1,3) %mA
Data(:,:,i) = [tempData.Segment1.data(:,2),tempData.Segment1.data(:,1)];
z(:,i) = current;
% plot3(x,y,repmat(current,size(x)))
end

figure('Units','centimeter','Position',[10 10 30 12],'PaperPositionMode','auto')
X = squeeze(Data(:,1,:));
Y = squeeze(Data(:,2,:));
Z = z;
mesh(X,Y,Z)
view([-20,20,-45])
camup([0 1 0]);
set(gca,'Xdir','reverse')
xlabel('Comprimento de onda [m]','interpreter','latex','FontSize',12)
ylabel('Potencia Optica [dBm]','interpreter','latex','FontSize',12)
zlabel('Corrente do Laser diodo [mA]','interpreter','latex','FontSize',12)
fig1=figure(1);
fig1.Renderer='Painters';
% saveas(gcf, 'out.eps', 'epsc');
% epsclean('espectrosmesh_2017.eps','groupSoft',true);
