% visualizaçao inicial para recebimento das grades
clear all

format long e
num_grad1 = input('Numero da grade de inicio: ');
num_grad2 = input('Numero da grade final: ');
% arq = 'DATA000.txt';

% visualiza as curvas de espectro em arquivos em separado
for i = num_grad1 : num_grad2
    clear a;
    kk = i;
    arq(7) = 48 + mod(kk,10);
    kk = floor(kk/10);
    arq(6) = 48 + mod(kk,10);
    kk = floor(kk/10);
    arq(5) = 48 + mod(kk,10);
    a = load (arq);
        for j = 1 : size(a,1)
            if a(j,2) <= 1e-9
            a(j,2) = 999999;
            end
        end
        for j = 1 : size(a,1)
            if a(j,2) == 999999
            a(j,2) = min(a(:,2));
            end
        end
    a(:,2) = 10*log10(a(:,2)/1e-3);
    figure(i)
    plot(a(:,1),a(:,2),'LineWidth',2)
    xlabel('Comprimento de onda (nm)')
    ylabel('Intensidade (dBm)')
end