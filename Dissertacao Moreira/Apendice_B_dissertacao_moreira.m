% Criado por Haroldo Takashi Hatori em 11/10/2000
% Modificado por Rogério Moreira Cazo em 31/10/2000
clear;
dn = 10^(-4.5); % valores adotados: 1e-5 ; 1e-4.5; 1e-4
format long;
% lambdak- array que contem os comprimentos de onda
for jj=1:4000
    lambdak(jj)=1550.0+0.00025*(jj-2000.0);
    lambdak(jj)=lambdak(jj)*1e-9;
end;
% beta1 = constante de fase da onda normalizada
% wart = periodo da grade de Bragg
% kold = coeficiente de acoplamento.
beta1 = 1.45;
wart = 5.360260082126142e-007;
kold = 2.033120705980911e+002;
lt1 = 10e-3;
% lt1 = comprimento da grade
% Vario o comprimento de onda
for jj = 1:4000
    lambda = lambdak(jj);
    % Comeca o loop das secoes
    k1(jj) = pi * dn / lambda;
    kold = k1(jj);
    dbeta1 = 2.0*pi*(2*beta1-lambda/wart)/lambda;
    delt1 = dbeta1/2.0;
    gamma1 = sqrt(kold^2-delt1^2);
    % coeficientes da matriz basica para UMA secao
    t1(1,1)=(cosh(gamma1*lt1)+i*delt1*sinh(gamma1*lt1)/gamma1)*...
    exp(i*pi*lt1/wart);
    t1(2,2)=(cosh(gamma1*lt1)-i*delt1*sinh(gamma1*lt1)/gamma1)*...
    exp(-1.0*i*pi*lt1/wart);
    t1(1,2)=-1.0*kold*sinh(gamma1*lt1)*exp(-1.0*i*pi*lt1/wart)/gamma1;
    t1(2,1)=-1.0*kold*sinh(gamma1*lt1)*exp(i*pi*lt1/wart)/gamma1;
    % Acaba seu loop de secoes. calcula a refletividade
    r1(jj)=abs(t1(2,1)/t1(1,1))^2;
    tr1(jj)=1/abs(t1(1,1))^2;
    r2(jj)=1.0-tr1(jj);
end;

figure (1)
plot (lambdak,r1); hold on;