% Standard plot chosen for dissertation
close all

gr=(1+sqrt(5))/2;
w=7;
size = [w*gr w];
fontsize = 12;
legendsize = 10;

figure('Units','centimeter','Position',[10 10 size],...
    'PaperPositionMode','auto')

    plot(time{i}, v1{i},'Color', c)
        ylim([0 10])
        xlim([0.3 0.5])
        ylabel('Output [V]','Interpreter', 'Latex')
        xlabel('Time [s]', 'Interpreter', 'Latex')
        set(gcf,'renderer','painters')
        set(gca, 'FontSize', fontsize)

saveas(gcf, 'out.eps', 'epsc2');  % save data in vectorized form