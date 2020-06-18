% This program collects all the spectrum data in the folder in one 3D array
% and plots all the spectrums.
% clear all
% close all
% clc
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')

dir = uigetdir('D:\Users\Stinky\Google Drive\ITA\Disciplinas\Aquisicao de dados LabVIEW\Projeto\Dados adquiridos');
addpath(dir)
extension = '.lvm';

N = input('Qual o numero do ultimo arquivo na pasta?   R:');

tempData = importdata('LabVIEW Data 0 .lvm');
y = tempData(:,2); %dBm
x = tempData(:,3); %mx
current = tempData(1,4); %mA

z = ones(length(x),1);
tempMatrix = zeros(0,N);
% figure
% hold on
for i=1:N+1
file = ['LabVIEW Data',' ',num2str(i-1),' ',extension];
tempData = importdata(file);
y = tempData(:,2); %dBm
x = tempData(:,3); %m
current = tempData(1,4) %mA
Data(:,:,i) = [tempData(:,3),tempData(:,2)];
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
% fig1=figure(1);
% fig1.Renderer='Painters';
% saveas(gcf, 'out.eps', 'epsc');
% epsclean('espectrosmesh_2017.eps','groupSoft',true);
