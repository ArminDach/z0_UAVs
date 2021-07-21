function z0 = Munro(x, grid)
%Surface roughness height estimation.
%   z0 = Munro(x, grid) returns an estimate of z0 based on
%   Smith's(2017) DEM-based z0 approach.  
%
%   Munro(x,grid) accepts 'x' as a position-array (in meters) and 
%   'grid' as surface elevations which will be linearly detrended. 
%
%   Written by Armin Dachauer, Msc Student, Atmospheric and Climate
%   Science, ETH Zurich.
%   Reference: Munro, D. S., 1989: Surface roughness and bulk heat transfer on a glacier: comparison with eddy correlation. Journal of Glaciology, 35 (121), 343-348, doi:10.1017/S0022143000009266.


%Initialize parameters
rs_x = size(grid,2); 
rs_y = size(grid,1); 
X = x(rs_x)-x(1) + (x(2)-x(1));   %Length of row in m
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
    h_star = 2*nanstd(norm_z(:)); 
    s = h_star*X/(2*f);
    S = (X/f)^2; 
    z01(ii) = 0.5*h_star*s/S;
end
z01(z01==0) = NaN; 
z0 = z01;
