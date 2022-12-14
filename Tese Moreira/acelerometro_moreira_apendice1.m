% This script is in Moreiras' Thesis and simulates the response of an
% accelerometer measuring element proportional to the chosen input. Ploting
% a 3D model of the calculated response.

% Limite de opera�ao da grade de Bragg: 1500uS

set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
clear all
close all
clc

grava_relatorio = 1;
desenha = 1;
grava_figura = 0;
arquivo = 'output_test.txt';
massaprestrain = 70e-3;

carrot = [230/256 126/256 34/256];
turquesa = [26/256 188/256 156/256];
belize = [41/256 128/256 185/256];


aresta = 8.2e-3; % => massa 11.696117g
% Angulos de rotacao da massa sismica ao redor de seu centro de massa,
% segundo suas coordenadas iniciais, em graus
alfa = 0.00; % rota�ao ao redor do eixo x
beta = 0.00; % rota�ao ao redor do eixo y originalmente = 10.00
gama = 0.00; % rota�ao ao redor do eixo z % .04 maximo para menor cubo
% deslocamento do centro da massa sismica (em uS)
dx = 0; %250000
dy = 0;
dz = 0;
% Densidade dos possiveis materiais a serem empregados no projeto
al = 2.6989; aco1005 = 7.872; latao = 8.8; cobre = 8.96; chumbo = 11.34;
ouro = 19.32;
densidade =[al aco1005 latao cobre chumbo ouro] * 1e3; % densidades emkg/m3
nomemat = ['aluminio';'aco 1005';'latao   ';'cobre   ';'chumbo  ';'ouro    '];
al = 1; aco1005 = 2; latao = 3; cobre = 4; chumbo = 5; ouro = 6;
format long
forca = [0 0 0];
momentott = [0 0 0];
for kkk = 1 : 1
    % dimensao de metade da aresta do cubo de massa sismica em metros
    a = aresta;
    buraco = .5e-3;%aresta - .5e-3;
    parede_centro = a+14e-3; % distancia entre a parede de sustenta�ao doconjunto e o centro da peca
    h = parede_centro - a;
    d = (a - 1e-3-1e-3/2+125e-6/2); % posicionamento do ponto de colagem dafibra optica na aresta do cubo, considerando di�metro do furo de 1mm,distancia da parede 1mm e di�metro da fibra 125um;
    %d = .5e-3 - 125e-6/2;
    di = 125e-6; % diametro da fibra optica
    s = pi*(di/2)^2; % area da fibra optica (m2)
    Y = 7.545898E+10; % modulo de young da fibra (N/m2)
    furo = 1e-3; % diametro do furo de passagem da fibra;
    furo = furo / 2;
    h0 = h;
    strain0(1:12) = massaprestrain*10/s/Y; % pre-tensao da fibra, devido a uma massa de 146g
    material = al;
    massa = ((2*a)^3 -6 * pi*furo^2*(2*a))* densidade(material); % massa do cubo, em kg
    % momento de inercia do cubo perfeito, com relacao ao eixo que passa
    % pelo centro de uma face, ortogonal `a mesma
    Icubo = massa * (2*a)^2/6;
    Itt = Icubo;
    h = h + a;
    k = 1.1; % fator de desalinhamento
    m = -1; % assimetria = -1; simetrico = 1
    cc = [-a a a; a a a; a -a a; -a -a a; -a a -a; a a -a; a -a -a; -a -a -a]; % coordenadas iniciais das arestas do cubo, na forma x,y,z
    ff = [-d a 0; d a 0; -d -a 0; d -a 0; -a 0 d; a 0 d; -a 0 -d; a 0 -d; 0 d a; 0 -d a; 0 d -a; 0 -d -a]; % coordenadas iniciais dos pontos de apoioda fibra no cubo de massa sismica, na forma x,y,z
    ffb = [-d h 0; d h 0; -d -h 0; d -h 0; -h 0 d; h 0 d; -h 0 -d; h 0 -d;0 d h; 0 -d h; 0 d -h; 0 -d -h]; % coordenadas dos pontos de apoio dasfibras na estrutura de suporte
    ff0 = ff; ffb0 = ffb;
    aa = a;
    cc = [cc ; ff];
    % Angulos de rotacao da massa sismica ao redor de seu centro de massa,
    % segundo suas coordenadas iniciais
    alfa = alfa * pi/180; % rota�ao ao redor do eixo x
    beta = beta * pi/180; % rota�ao ao redor do eixo y
    gama = gama * pi/180; % rota�ao ao redor do eixo z % .08 maximo para menor cubo
    % deslocamento do centro da massa sismica
    dx = dx*h0*1e-6;
    dy = dy*h0*1e-6;
    dz = dz*h0*1e-6;
    % transforma�ao para coordenadas esfericas e rota�ao nos tres eixos
    for j = 1 : 3
            if j == 1
            a = 1; b = 2; c = 3; rotacao = gama;
            else
                if j == 2
                a = 2; b = 3; c = 1; rotacao = alfa;
                else a = 3; b = 1; c = 2; rotacao = beta;
                end
            end
        for i = 1 : size(cc,1)
            roc(i) = (cc(i,a)^2 + cc(i,b)^2 + cc(i,c)^2)^.5;
            phi(i) = atan2((cc(i,a)^2 + cc(i,b)^2)^.5,cc(i,c));
            teta(i) = atan2(cc(i,b),cc(i,a));
            teta(i) = teta(i) + rotacao;
            cc(i,a) = roc(i)*sin(phi(i))*cos(teta(i));
            cc(i,b) = roc(i)*sin(phi(i))*sin(teta(i));
            cc(i,c) = roc(i)*cos(phi(i));
        end
    end
    % translacao nos tres eixos
    cc(:,1) = cc(:,1) + dx;
    cc(:,2) = cc(:,2) + dy;
    cc(:,3) = cc(:,3) + dz;
    ff = cc(9:20,:);
    for i = 1 : size(ffb,1)
        % Determina a deformacao normalizada de cada fibra optica (strain)
        comprimento(i) = dot(ff(i,:)-ffb(i,:),ff(i,:)-ffb(i,:))^.5;
        comprimento0(i) = dot(ff0(i,:)-ffb0(i,:),ff0(i,:)-ffb0(i,:))^.5;
        % strain(i) = strain0(i) + (comprimento(i) -comprimento0(i))/comprimento0(i);
        % considerando-se a influencia do strain inicial
        strain(i) = strain0(i) + (1 + strain0(i)) * (comprimento(i) -comprimento0(i))/comprimento0(i);
        % forca em cada fibra na foma escalar
        forcaE(i) = strain(i) * s * Y;
        % forca em cada fibra na forma vetorial
        forcaV(i,:) = - forcaE(i) * (ff(i,:) - ffb(i,:))/comprimento(i);
        % forca total agindo no cubo
        forca = forca + forcaV(i,:);
        % momento no cubo devido aas forcas individuais, com relacao ao
        % centro do sistema de apoio
        momento(i,:) = -cross(ff(i,:),forcaV(i,:));
        % total do momento aplicado aa estrutura
        momentott = momentott + momento(i,:);
    end
    AcelAngular = momentott / Itt;
    if desenha == 1
        % Desenha o cubo em 3d
        i = 1; x = [cc(1,i) cc(2,i) cc(3,i) cc(4,i) cc(1,i) cc(5,i) cc(6,i) cc(7,i) cc(8,i) cc(5,i)];
        i = 2; y = [cc(1,i) cc(2,i) cc(3,i) cc(4,i) cc(1,i) cc(5,i) cc(6,i) cc(7,i) cc(8,i) cc(5,i)];
        i = 3; z = [cc(1,i) cc(2,i) cc(3,i) cc(4,i) cc(1,i) cc(5,i) cc(6,i) cc(7,i) cc(8,i) cc(5,i)];
        subplot(2,2,1), plot3(x,y,z,'k','LineWidth',1.5); hold on
        subplot(2,2,2), plot3(x,y,z,'k','LineWidth',1.5); hold on
        subplot(2,2,3), plot3(x,y,z,'k','LineWidth',1.5); hold on
        subplot(2,2,4), plot3(x,y,z,'k','LineWidth',1.5); hold on
        clear x y z
        x = [cc(2,1) cc(6,1)]; y = [cc(2,2) cc(6,2)]; z = [cc(2,3) cc(6,3)];
        subplot(2,2,1),plot3(x,y,z,'k','LineWidth',1.5);subplot(2,2,2),plot3(x,y,z,'k','LineWidth',1.5);subplot(2,2,3),plot3(x,y,z,'k','LineWidth',1.5);subplot(2,2,4),plot3(x,y,z,'k','LineWidth',1.5);
        x = [cc(3,1) cc(7,1)]; y = [cc(3,2) cc(7,2)]; z = [cc(3,3) cc(7,3)];
        subplot(2,2,1),plot3(x,y,z,'k','LineWidth',1.5);subplot(2,2,2),plot3(x,y,z,'k','LineWidth',1.5);subplot(2,2,3),plot3(x,y,z,'k','LineWidth',1.5);subplot(2,2,4),plot3(x,y,z,'k','LineWidth',1.5);
        x = [cc(4,1) cc(8,1)]; y = [cc(4,2) cc(8,2)]; z = [cc(4,3) cc(8,3)];
        subplot(2,2,1),plot3(x,y,z,'k','LineWidth',1.5);subplot(2,2,2),plot3(x,y,z,'k','LineWidth',1.5);subplot(2,2,3),plot3(x,y,z,'k','LineWidth',1.5);subplot(2,2,4),plot3(x,y,z,'k','LineWidth',1.5);

        % Desenha os pontos de apoio das fibras no cubo
        for i = 1 : size(ff,1)
            subplot(2,2,1), plot3(ff(i,1),ff(i,2),ff(i,3),'kx');
            % text(ff(i,1),ff(i,2),ff(i,3),num2str(i)); %para mostrar texto
            subplot(2,2,2), plot3(ff(i,1),ff(i,2),ff(i,3),'kx');
            % text(ff(i,1),ff(i,2),ff(i,3),num2str(i));
            subplot(2,2,3), plot3(ff(i,1),ff(i,2),ff(i,3),'kx');
            % text(ff(i,1),ff(i,2),ff(i,3),num2str(i));
            subplot(2,2,4), plot3(ff(i,1),ff(i,2),ff(i,3),'kx');
            % text(ff(i,1),ff(i,2),ff(i,3),num2str(i));
        end
        % Desenha os pontos de apoio das fibras na estrutura de suporte
        for i = 1 : size(ffb,1)
            subplot(2,2,1), plot3(ffb(i,1),ffb(i,2),ffb(i,3),'Color',belize,'Marker','o')
            subplot(2,2,2), plot3(ffb(i,1),ffb(i,2),ffb(i,3),'Color',belize,'Marker','o')
            subplot(2,2,3), plot3(ffb(i,1),ffb(i,2),ffb(i,3),'Color',belize,'Marker','o')
            subplot(2,2,4), plot3(ffb(i,1),ffb(i,2),ffb(i,3),'Color',belize,'Marker','o')
        end
        % Desenha as fibras opticas entre estrutura de apoio e massasismica
        for i = 1 : size(ffb,1)
            subplot(2,2,1), plot3([ff(i,1) ffb(i,1)], [ff(i,2) ffb(i,2)],[ff(i,3) ffb(i,3)],'Color', belize,'LineWidth',2)
            subplot(2,2,2), plot3([ff(i,1) ffb(i,1)], [ff(i,2) ffb(i,2)],[ff(i,3) ffb(i,3)],'Color', belize,'LineWidth',2)
            subplot(2,2,3), plot3([ff(i,1) ffb(i,1)], [ff(i,2) ffb(i,2)],[ff(i,3) ffb(i,3)],'Color', belize,'LineWidth',2)
            subplot(2,2,4), plot3([ff(i,1) ffb(i,1)], [ff(i,2) ffb(i,2)],[ff(i,3) ffb(i,3)],'Color', belize,'LineWidth',2)
        end

        % Desenha eixos coordenados
        % subplot(2,2,1), plot3([0 d/2], [0 0], [0 0], 'k','LineWidth',0.1);
        % text(d/2,0,0,'X'); plot3([0 0], [0 d/2], [0 0], 'k','LineWidth',0.1);
        % text(0,d/2,0,'Y'); plot3([0 0], [0 0], [0 d/2], 'k','LineWidth',0.1);
        % text(0,0,d/2,'Z');
        % subplot(2,2,2), plot3([0 d/2], [0 0], [0 0], 'k','LineWidth',0.1);
        % text(d/2,0,0,'X'); plot3([0 0], [0 d/2], [0 0], 'k','LineWidth',0.1);
        % text(0,d/2,0,'Y'); plot3([0 0], [0 0], [0 d/2], 'k','LineWidth',0.1);
        % text(0,0,d/2,'Z');
        % subplot(2,2,3), plot3([0 d/2], [0 0], [0 0], 'k','LineWidth',0.1);
        % text(d/2,0,0,'X'); plot3([0 0], [0 d/2], [0 0], 'k','LineWidth',0.1);
        % text(0,d/2,0,'Y'); plot3([0 0], [0 0], [0 d/2], 'k','LineWidth',0.1);
        % text(0,0,d/2,'Z');
        % subplot(2,2,4), plot3([0 d/2], [0 0], [0 0], 'k','LineWidth',0.1);
        % text(d/2,0,0,'X'); plot3([0 0], [0 d/2], [0 0], 'k','LineWidth',0.1);
        % text(0,d/2,0,'Y'); plot3([0 0], [0 0], [0 d/2], 'k','LineWidth',0.1);
        % text(0,0,d/2,'Z');


        %view(0,0)
        subplot(2,2,1)
        axis square; axis tight; grid on
        xlabel('x')
        ylabel('y')
        zlabel('z')
        hold off
        subplot(2,2,2)
        view(0,0)
        axis square; axis tight; grid on
        xlabel('x')
        ylabel('y')
        zlabel('z')
        hold off
        subplot(2,2,3)
        view(0,90)
        axis square; axis tight; grid on
        xlabel('x')
        ylabel('y')
        zlabel('z')
        hold off
        subplot(2,2,4)
        view(90,0)
        axis square; axis tight; grid on
        xlabel('x')
        ylabel('y')
        zlabel('z')
        hold off
        figure(1)
        if grava_figura == 1
            pasta = 'c:imagens\';
            arq = 'cubo00';
            arquivo = arq;
            arquivo(6) = 48 + mod(kkk,10);
            arquivo(5) = 48 + floor(kkk/10);
            arquivo = [pasta arquivo];
            figure(1)
            print( gcf, '-dmeta', arquivo )
            end
        end
end
Dstrain(1,1) = strain(6) - strain(7); Dstrain(1,2) = strain(8) - strain(5);
% DS equivalente aa aceleracao no eixo x
Dstrain(2,1) = strain(1) - strain(4); Dstrain(2,2) = strain(2) - strain(3);
% DS equivalente aa aceleracao no eixo y
Dstrain(3,1) = strain(10) - strain(11); Dstrain(3,2) = strain(9) -strain(12); % DS equivalente aa aceleracao no eixo z
Dstrain(4,1) = strain(12) - strain(11); Dstrain(4,2) = strain(9) -strain(10); % DS equivalente aa rotacao ao redor do eixo x
Dstrain(5,1) = strain(7) - strain(5); Dstrain(5,2) = strain(6) - strain(8);
% DS equivalente aa rotacao ao redor do eixo y
Dstrain(6,1) = strain(3) - strain(4); Dstrain(6,2) = strain(2) - strain(1);
% DS equivalente aa rotacao ao redor do eixo z
if grava_relatorio == 1
    fid = fopen(arquivo,'w');
    fprintf(fid,'Analise de deformacoes para acelerometro a fibra optica\n\n')
    if max(strain*1e6) > 1500
        load splat
        sound (y,Fs)
        fprintf(fid,'FIBRA ARREBENTA\n\n');
    end
    if min(strain*1e6) < 0
        load splat
        sound (y,Fs)
        fprintf(fid,'FIBRA SOLTA\n\n');
    end
    fprintf(fid,'Aresta do cubo (mm): %4.4f\n',2*aa*1000);
    fprintf(fid,'Material do cubo: %s\n',nomemat(material,:));
    fprintf(fid,'Distancia entre furos (mm): %4.4f\n',2*d*1000);
    fprintf(fid,'Comprimento ativo de fibra (mm): %4.4f\n',h0*1000);
    fprintf(fid,'Massa equivalente ao pre-strain (g):%4.4f\n',massaprestrain*1000);
    fprintf(fid,'Pre-strain da fibra optica (uS): %4.4f\n',strain0(1)*1e6);
    fprintf(fid,'Massa do cubo (g): %4.6f\n',massa*1e3);
    fprintf(fid,'Momento de inercia do cubo (g*mm^2): %4.6f\n\n',Itt*1e3);
    fprintf(fid,'Rota�oes impostas ao redor de x, y e z (graus): \n%4.6f%4.6f %4.6f\n\n',alfa*180/pi,beta*180/pi,gama*180/pi);
    fprintf(fid,'Translacoes impostas ao longo de x, y e z (um): \n%4.6f%4.6f %4.6f\n\n',1e6*dx,1e6*dy,1e6*dz);
    fprintf(fid,'Aceleracoes lineares estimadas (x, y, z) (m/s^2):\n %4.6f%4.6f %4.6f\n\n',forca'/massa);
    fprintf(fid,'Aceleracoes lineares estimadas (x, y, z) (G):\n %4.6f%4.6f %4.6f\n\n',forca'/massa/10);
    fprintf(fid,'Aceleracoes angulares estimadas, ao redor de x, y e z(rad/s^2):\n %4.6f %4.6f %4.6f\n\n',AcelAngular);
    fprintf(fid,'Deforma�ao normalizada (strain) de cada fibra (uS)\n');
    for i = 1 : 4
        fprintf(fid,'Fibra %d: %4.6f\tFibra %d: %4.6f\tFibra %d:%4.6f\n',3*(i-1)+1,strain(3*(i-1)+1)*1e6,3*(i-1)+2,strain(3*(i-1)+2)*1e6,3*(i-1)+3,strain(3*(i-1)+3)*1e6);
    end
    fprintf(fid,'\nStrain diferencial para cada medida (uS):\n');
    fprintf(fid,'Devido a aceleracao no eixo x: %4.6f%4.6f\n',Dstrain(1,:)*1e6);
    fprintf(fid,'Devido a aceleracao no eixo y: %4.6f%4.6f\n',Dstrain(2,:)*1e6);
    fprintf(fid,'Devido a aceleracao no eixo z: %4.6f%4.6f\n',Dstrain(3,:)*1e6);
    fprintf(fid,'Devido a rotacaoao redor do eixo x: %4.6f%4.6f\n',Dstrain(4,:)*1e6);
    fprintf(fid,'Devido a rotacaoao redor do eixo y: %4.6f%4.6f\n',Dstrain(5,:)*1e6);
    fprintf(fid,'Devido a rotacaoao redor do eixo z: %4.6f%4.6f\n',Dstrain(6,:)*1e6);
    % fprintf(fid,'\nForcas que agem em cada fibra (N):\n');
    % fprintf(fid,'%12.8f %12.8f %12.8f\n',forcaV');
    fclose(fid);
    edit (arquivo);
end