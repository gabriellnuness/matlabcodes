%%  FFT function to compare frequency of input signal x output signal
% fft_plot(t,V,log,c)
% V = signal to be analyzed
% t = time array
% log = plot logaritmic scale when log=1.
% c [optional] = plot color in the format rbg [0-1,0-1,0-1]

function FFT_plot(t,V,log,c)
%optional param c
if ~exist('c','var')
 % third parameter does not exist, so default it to something
  c = [0.3,0.3,0.3];
end

N = length(V);
Ts = t(2)-t(1);
fs = 1/Ts;
fN = fs/2;
tt=(0:N-1)*Ts;

fft1 = fft(V);
P2 = abs(fft1/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f=fs*(0:(N/2))/N;

if log == 1
    % figure
    h = plot(f,P1,'-','MarkerSize',10,'Color',c) ;
    set(gca,'YScale','log') %Y in decibels
else
    % figure
    h = plot (f,P1,'-','MarkerSize',10,'Color',c);
end

%% placing data tip in maximum values
X = P1;

% finding max values sequentially

% [max1, ind1] = max(X);
% X(ind1)      = -Inf;
% [max2, ind2] = max(X);
% X(ind2)      = -Inf;
% 
% if f(ind1) ~= 0
%     datatip(h,'DataIndex',int16(f(ind1)))
% end
% datatip(h,'DataIndex',int16(ind2))

% local max is more representative than just sorting maximum values

% TF = islocalmax(X,'MinSeparation',15);
TF = islocalmax(X,'MinProminence',4/100); % 0.05
hold on
belize = [41/255 128/255 185/255];
plot(f(TF),X(TF),'.','MarkerSize',10,'Color',belize)
legend('FFT', ['f [Hz] = ',num2str(f(TF))])

end

