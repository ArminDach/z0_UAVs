function z0 = Lettau(x, grid)
%Surface roughness height estimation.
%   z0 = Lettau(x, grid) returns an estimate of z0 based on the
%   zero-up-crossing method introduced by Lettau (1969). 
%
%   Lettau(x,grid) accepts 'x' as a position-array (in meters) and 
%   'grid' as surface elevations which will be linearly detrended. 
%
%   Written by Armin Dachauer, Msc Student, Atmospheric and Climate
%   Science, ETH Zurich.
%   Reference: Lettau, H., 1969: Note on aerodynamic roughness-parameter estimation on the basis of roughness-element description. Journal of applied meteorology, 8 (5), 828-832.

%Initialize parameters
rs_x = size(grid,2);  
rs_y = size(grid,1);
X = x(rs_x)-x(1) + (x(2)-x(1));  %Length of row in m
z01 = NaN(rs_x,1);

%Calculation
for ii = 1:rs_y
    z = grid(ii,:);
    %linear detrending for each row
    z = z(~isnan(z));  %delete NaN's in row
    norm_z = detrend(z);  
    pos = (norm_z>0);
    changes = xor(pos(1:end-1),pos(2:end));  
    for ij = 1:length(norm_z)-1   
        if norm_z(ij) > 0
            changes(ij) = 0;
        end
    end
    f = sum(changes); 
    if ~isempty(changes) && changes(1)~=1  %Due to border elements
        f = f+1;
    end
    h = norm_z - nanmin(norm_z);  
    h_star = nanmean(h);
    s = h_star*X/(2*f);
    S = (X/f)^2;
    z01(ii) = 0.5*h_star*s/S;
end
z0 = nanmean(z01);
