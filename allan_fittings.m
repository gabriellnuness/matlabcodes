function [arw,rrw,bias] = allan_fittings(taus, adev)
% Fittings ARW, RRW, and Bias drift from Allan deviation plot

% Angle random walk
    slope = -1/2; k = 1;

    logtau = log10(taus);
    logadev = log10(adev);
    dlogadev = diff(logadev) ./ diff(logtau);
    [~, i] = min(abs(dlogadev - slope));
    
    % Find the y-intercept of the line.
    b = logadev(i) - slope*logtau(i);
    
    % Determine the angle random walk coefficient from the line.
    logN = slope*log(k) + b;
    arw = 10^logN;

% Rate Random Walk
    slope = 1/2; k = 3;

    [~, i] = min(abs(dlogadev - slope));
    b = logadev(i) - slope*logtau(i);
    logK = slope*log10(k) + b;
    rrw = 10^logK;

% Bias drift
    slope = 0;

    [~, i] = min(abs(dlogadev - slope));
    b = logadev(i) - slope*logtau(i);
    scfB = sqrt(2*log(2)/pi);  % 0.6643
    logB = b - log10(scfB);
    bias = 10^logB;

end