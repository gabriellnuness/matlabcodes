function [taus, avar] = calc_avar(data,fs,pts)
% This function calculates the Allan variance
%
% Input: - data
%        - fs = Sample frequency   

    N = length(data);
    int_data = cumsum(data)/fs;
    max_m = 2^floor(log2(N/2)); % Max m in defined by power of 2
    m = logspace(0, log10(max_m), pts)';
    m = ceil(m);        
    m = unique(m);
    
    tau0 = 1/fs;
    taus = m*tau0;      % Cluster durations
    
    avar = zeros(length(m), 1);
    % Half vectorized approach
    tic
    for k = 1:length(m)
        avar(k) = sum( (int_data(k+2*m(k):N) - 2*int_data(k+m(k):N-m(k)) + int_data(k:N-2*m(k))).^2 );
    end
    avar = avar./(2.*taus.^2 .* (N-2*m));
    toc
end