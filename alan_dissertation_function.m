function[fs,as] = alan_dissertation_function(vs,t)
% Function from the master's dissertation of Alan Wilson
% It is used to calculate the natural frequency and to fit the exponential
% function of a damping signal


	vs=vs-mean(vs);
	%domniodafreque^encia
	vf=abs(2*fft(vs)/length(vs));%amplitudes
	f=(0:length(vs)-1)./(max(t)-min(t));%frequ^encias
	vf=vf(1:round(length(vs)/2));
	f=f(1:round(length(vs)/2));
	%frequenciadepico
	[~,p]=max(vf);
	%encontrar minimos laterais(limites para calculo da media)
	p1=p(1);
	p2=p(1);
	aux=0.5*max(vf);
	while vf(p1)>aux&&p1>1%lado esquerdo
		p1=p1-1;
	end

	while vf(p2)>aux&&p2<length(f)%lado direito
		p2=p2+1;
	end
	%encontrar frequencia central
	fs=trapz(f(p1:p2),f(p1:p2).*vf(p1:p2))/trapz(f(p1:p2),vf(p1:p2));
	%valores de pico
	[~,p1]=findpeaks(vs,'MinPeakHeight',0);
	[~,p2]=findpeaks(-vs,'MinPeakHeight',0);
	while length(p1)>length(p2)
		p1=p1(1:end-1);
	end
	while length(p1)<length(p2)
		p2=p2(1:end-1);
	end
	vpp=vs(p1)-vs(p2);
	tpp=t(p1);
	%identificar decaimento
	pol=polyfit(tpp,log(vpp),1);
	as=real(pol(1));
    as = -2*as;
end
