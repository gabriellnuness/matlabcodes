% This program collects all the single points data in the folder and
% groups them into one file only
%%
clc
set(groot,'defaultAxesTickLabelInterpreter','latex')
set(groot,'defaultLegendInterpreter','latex')

dir = uigetdir('D:\Users\Stinky\Google Drive\ITA\Disciplinas\Aquisicao de dados LabVIEW\Projeto\Dados adquiridos');
addpath(dir)
extension = '.lvm';
N = input('Qual o numero do ultimo arquivo na pasta?   R:');

tempMatrix = zeros(0,N);
for i=1:N+1
file = [dir,'\LabVIEW Data',' ',num2str(i-1),' ',extension];
tempData = importdata(file);
Data(i,2) = tempData(1,5); %m peak_lambda
Data(i,3) = tempData(1,6); %dBm peak_power
Data(i,1) = tempData(1,4); %mA current
end
'Acquisition is done'
%data11= Data;

%%
data11 = data11([1:88],:);
data12 = data12([1:88],:);
data13 = data13([1:88],:);
data14 = data14([1:88],:);
data15 = data15([1:88],:);
data16 = data16([1:88],:);
data17 = data17([1:88],:);
data18 = data18([1:88],:);
data19 = data19([1:88],:);
data20 = data20([1:88],:);

    
%% plots
figure
plot(Data(:,1),Data(:,2),'k')
title('Lambda')

%% Plot potência com Threshold automaticamente
figure('Units','centimeter','Position',[10 10 14 10.5],'PaperPositionMode','auto')
h= plot(Data(:,1),Data(:,3),'.k');
xlabel('Corrente aplicada no laser diodo [mA]','Interpreter','latex')
ylabel('Potencia opica [dBm]','Interpreter','latex')
[threshold]=ischange(Data(:,3),'MaxNumChanges',1);
index = find(threshold);
val = Data(index,1)
M = input('Qual o valor máximo no eixo Y?   R:');
m = input('Qual o valor mínimo no eixo Y?   R:');
line([val val],[M m],'Color',[199/255 44/255 28/255])
set(gca,'XTick',sort([val,get(gca,'XTick')]));
legend('','Threshold','Location','northwest')
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
grid

%% Error Calculation and plot with errorbar
for i=1:10
   index_data = eval(sprintf(strcat('data',num2str(i)),'1'));
   peak_lambda0(:,i) = index_data(:,2);
end

for i=1:10
   index_data = eval(sprintf(strcat('data',num2str(i)),'1'));
   peak_power0(:,i) = index_data(:,3);
end
current0 = data1(:,1);

for i=1:length(peak_lambda)
std_peak_lambda(i) = std(peak_lambda(i,:));
mean_peak_lambda(i) = mean(peak_lambda(i,:));
end
std_peak_lambda = std_peak_lambda';
mean_peak_lambda = mean_peak_lambda';

for i=1:length(peak_power)
std_peak_power(i) = std(peak_power(i,:));
mean_peak_power(i) = mean(peak_power(i,:));
end
std_peak_power = std_peak_power';
mean_peak_power = mean_peak_power';

%plot da potencia de pico x corrente com desvio padrao nas barras de erro
figure('Units','centimeter','Position',[10 10 10 7.5],'PaperPositionMode','auto')
errorbar(current0,mean_peak_power,std_peak_power,'--k')
xlabel('Corrente aplicada no laser diodo [mA]','Interpreter','latex')
ylabel('Potencia opica [dBm]','Interpreter','latex')
grid

%plot do comprimento de onda de pico x corrente com desvio padrao nas barras de erro
figure('Units','centimeter','Position',[10 10 10 7.5],'PaperPositionMode','auto')
errorbar(current0,mean_peak_lambda,std_peak_lambda,'--k')
xlabel('Corrente aplicada no laser diodo [mA]','Interpreter','latex')
ylabel('Comprimento de onda [m]','Interpreter','latex')
grid


%% Error Calculation and plot with errorbar
for i=11:20
   index_data = eval(sprintf(strcat('data',num2str(i)),'1'));
   peak_lambda1(:,i-10) = index_data(:,2);
end

for i=11:20
   index_data = eval(sprintf(strcat('data',num2str(i)),'1'));
   peak_power1(:,i-10) = index_data(:,3);
end
current1 = data11(:,1);

for i=1:length(peak_lambda)
std_peak_lambda(i) = std(peak_lambda(i,:));
mean_peak_lambda(i) = mean(peak_lambda(i,:));
end
std_peak_lambda = std_peak_lambda';
mean_peak_lambda = mean_peak_lambda';

for i=1:length(peak_power)
std_peak_power(i) = std(peak_power(i,:));
mean_peak_power(i) = mean(peak_power(i,:));
end
std_peak_power = std_peak_power';
mean_peak_power = mean_peak_power';

%plot da potencia de pico x corrente com desvio padrao nas barras de erro
figure('Units','centimeter','Position',[10 10 10 7.5],'PaperPositionMode','auto')
errorbar(current1,mean_peak_power,std_peak_power,'--k')
xlabel('Corrente aplicada no laser diodo [mA]','Interpreter','latex')
ylabel('Potencia opica [dBm]','Interpreter','latex')
grid

%plot do comprimento de onda de pico x corrente com desvio padrao nas barras de erro
figure('Units','centimeter','Position',[10 10 10 7.5],'PaperPositionMode','auto')
errorbar(current1,mean_peak_lambda,std_peak_lambda,'--k')
xlabel('Corrente aplicada no laser diodo [mA]','Interpreter','latex')
ylabel('Comprimento de onda [m]','Interpreter','latex')
grid

%%
peak_lambda= [peak_lambda0;peak_lambda1];
peak_power= [peak_power0;peak_power1];
current = [current0;current1];

for i=1:length(peak_lambda)
std_peak_lambda(i) = std(peak_lambda(i,:));
mean_peak_lambda(i) = mean(peak_lambda(i,:));
end
std_peak_lambda = std_peak_lambda';
mean_peak_lambda = mean_peak_lambda';

for i=1:length(peak_power)
std_peak_power(i) = std(peak_power(i,:));
mean_peak_power(i) = mean(peak_power(i,:));
end
std_peak_power = std_peak_power';
mean_peak_power = mean_peak_power';


%plot da potencia de pico x corrente com desvio padrao nas barras de erro
figure('Units','centimeter','Position',[10 10 10 7.5],'PaperPositionMode','auto')
hold on
shadedErrorBar(current,mean_peak_power,std_peak_power,'lineprops','b')
plot(current,mean_peak_power,'linewidth',1,'color','k')
xlabel('Corrente aplicada no laser diodo [mA]','Interpreter','latex')
ylabel('Potencia opica [dBm]','Interpreter','latex')
grid

belize = [41/256 128/256 185/256];

%%
%plot da potencia de pico x corrente com threshold
figure('Units','centimeter','Position',[10 10 14 10.5],'PaperPositionMode','auto')
hold on
% errorbar(current,mean_peak_power,std_peak_power,'k')
h = plot(current,mean_peak_power,'.k')
xlabel('Laser Diode Current [mA]','Interpreter','latex')
ylabel('Optical Power [dBm]','Interpreter','latex')
line([76 76],[-50 0],'Color',[199/255 44/255 28/255])
set(gca,'XTick',sort([76,get(gca,'XTick')]));
legend('','Threshold','Location','southeast')
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
grid

%plot do comprimento de onda de pico x corrente com desvio padrao nas barras de erro
figure('Units','centimeter','Position',[10 10 10 7.5],'PaperPositionMode','auto')
errorbar(current,mean_peak_lambda,std_peak_lambda,'--k')
xlabel('Corrente aplicada no laser diodo [mA]','Interpreter','latex')
ylabel('Comprimento de onda [m]','Interpreter','latex')
ylim([1.54913e-6 1.5491319e-6])
grid

%plot do comprimento de onda de pico x corrente com desvio padrao nas barras de erro
figure('Units','centimeter','Position',[10 10 14 10.5],'PaperPositionMode','auto')
plot(current,mean_peak_lambda,'k')
xlabel('Laser diode current [mA]','Interpreter','latex')
ylabel('Wavelength [m]','Interpreter','latex')
ylim([1.54913e-6 1.5491319e-6])
set(gca,'XTick',sort([76,get(gca,'XTick')]));
grid

%%
%plot da potencia de pico x corrente com desvio padrao na direita
figure('Units','centimeter','Position',[10 10 14 10.5],'PaperPositionMode','auto')
hold on
red = [199/255 44/255 28/255];
blue = [41/255 128/255 185/255];
yyaxis left
plot(current,mean_peak_power,'.k');
set(gca,'YColor','k')
xlabel('Laser Diode Current [mA]','Interpreter','latex')
ylabel('Optical Power [dBm]','Interpreter','latex')

yyaxis right
plot(current,std_peak_power,'Color',red)
ylabel('Standard Deviation [dBm]','Interpreter','latex')
set(gca,'YColor','k')
set(gca,'XTick',sort([76,get(gca,'XTick')]));
legend('Optical Power','Std Deviation','Location','southeast')
grid


%plot do comprimento de onda de pico x corrente com desvio padrao nas barras de erro
figure('Units','centimeter','Position',[10 10 14 10.5],'PaperPositionMode','auto')
yyaxis left
plot(current,mean_peak_lambda,'k')
set(gca,'YColor','k')
xlabel('Laser diode current [mA]','Interpreter','latex')
ylabel('Wavelength [m]','Interpreter','latex')
ylim([1.54913e-6 1.5491319e-6])
set(gca,'XTick',sort([76,get(gca,'XTick')]));
xlim([76 500])
yyaxis right
plot(current,std_peak_lambda,'Color',red)
ylabel('Standard Deviation [m]','Interpreter','latex')
set(gca,'YColor','k')
legend('Peak Wavelength','Std Deviation','Location','southeast')
grid