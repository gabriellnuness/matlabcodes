function fwhm = calc_fwhm(x,y,db)
% Function to calculate the FWHM of a given spectrum given in dBm.
%
% fwhm = calc_fwhm(x,y,db)
% 
% db = 1 --> measurement in dBm
% db = 0 --> measurement in mW

% Find the half max value.
if db == 1
    mid = max(y) -3; 
elseif db == 0
    mid = max(y) /2; 
end

% find first point
[ind1, pow1] = find(y >= mid, 1, 'first')

% interpolate if not exact match
if pow1 ~= mid
    ind1_1 = ind1-1
    
    xx = [x(ind1) x(ind1_1)];
    yy = [y(ind1) y(ind1_1)];
    c = [[1; 1]  xx(:)] \yy(:);
    m = c(2);
    b = c(1);
    
    lamb1 = (mid-b)/m;
else
    lamb1 = x(ind1);
end

% find second point
[ind2, pow2] = find(y >= mid, 1, 'last')

if pow2 ~= mid
    ind2_1 = ind2+1

    xx = [x(ind2) x(ind2_1)];
    yy = [y(ind2) y(ind2_1)];
    c = [[1; 1]  xx(:)] \yy(:);
    m = c(2);
    b = c(1);
    
    lamb2 = (mid-b)/m;
else
    lamb2 = x(ind2);
end

fwhm = lamb2 - lamb1;
end