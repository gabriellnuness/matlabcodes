%% Plot a graph with two y axis
% the tick label from right axis is changed to whatever unit is desired
% without having to plot the graph again, just the ticks are changed

figure('Units','centimeter','Position',[-30 10 14 10.5],'PaperPositionMode','auto')
hold on

yyaxis left
plot(freq,Gain,'-k','LineWidth',1)
xlabel('Frequency [kHz]','Interpreter','Latex','Color','k');
ylabel('Scale Factor [rad/V]','Interpreter','Latex','Color','k');
xlim([20 310])
set(gca,'YColor','k')
    

L = 10e-3; % Vinicius Mofo length in meters
ax = gca;
rad_v = ax.YTick; % ticks from yyaxis left
rad_v_m = rad_v/L;
rad_v_m = num2str(rad_v_m);%to number
rad_v_m = strsplit(rad_v_m); %converting each string to cell
lim = ax.YLim

yyaxis right
set(gca,'YColor','k')
% set(gca,'YTickMode','manual')
set(gca,'YLim',lim)
set(gca,'YTickLabel',rad_v_m)
grid minor



