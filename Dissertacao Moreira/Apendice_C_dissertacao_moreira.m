clear;
format long;
var = 1000;
dl = 2.5/var;

for jj=1:var
lambdak(jj)=1550.4+dl*(jj-var/2);
lambdak(jj)=lambdak(jj)*1e-9;
end;

ltot=1e-3;
ntot=80;
lt1=ltot/ntot;
beta1=1.44582536691503;
warto=5.360260082126142e-007;
kold=2.033120705980911e+002;

for rr=1:ntot
wart(rr)=warto+0.25e-9*(rr-1)/ntot;
end;

for jj=1:var
lambda=lambdak(jj);
dbeta1=2.0*pi*(2*beta1-lambda/warto)/lambda;
delt1=dbeta1/2.0;
gamma1=sqrt(kold^2-delt1^2);
t1(1,1)=(cosh(gamma1*lt1)+i*delt1*sinh(gamma1*lt1)/gamma1)*exp(i*pi*lt1/warto);
t1(2,2)=(cosh(gamma1*lt1)-i*delt1*sinh(gamma1*lt1)/gamma1)*exp(-1.0*i*pi*lt1/warto);
t1(1,2)=-1.0*kold*sinh(gamma1*lt1)*exp(-1.0*i*pi*lt1/warto)/gamma1;
t1(2,1)=-1.0*kold*sinh(gamma1*lt1)*exp(i*pi*lt1/warto)/gamma1;
tnew=t1;
fas1=0.0;
    for rr=2:ntot
    fas1=fas1+2.0*pi*lt1/wart(rr);
    dbeta1=2.0*pi*(2*beta1-lambda/wart(rr))/lambda;
    delt1=dbeta1/2.0;
    gamma1=sqrt(kold^2-delt1^2);
    t1(1,1)=(cosh(gamma1*lt1)+i*delt1*sinh(gamma1*lt1)/gamma1)*exp(i*pi*lt1/wart(rr));
    t1(2,2)=(cosh(gamma1*lt1)-i*delt1*sinh(gamma1*lt1)/gamma1)*exp(-1.0*i*pi*lt1/wart(rr));
    t1(1,2)=-1.0*kold*sinh(gamma1*lt1)*exp(-1.0*i*(pi*lt1/wart(rr)+fas1))/gamma1;
    t1(2,1)=-1.0*kold*sinh(gamma1*lt1)*exp(i*(pi*lt1/wart(rr)+fas1))/gamma1;
    tnew=tnew*t1;
    end;
lal=tnew(2,1)/tnew(1,1);
r1(jj)=abs(lal)^2;
phs2(jj)=-1.0*angle(lal);
tr1(jj)=1/abs(tnew(1,1))^2;
r2(jj)=1.0-tr1(jj);
end;

figure (1)
plot (lambdak*1e9,r1);
axis([1550.4-dl*var/2 1550.4+dl*var/2 0 1]);
xlabel('Comprimento de onda (nm)');
ylabel('Intensidade normalizada');