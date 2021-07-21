function z0 = Chambers(x, grid)
%Surface roughness height estimation.
%   z0 = Chambers(x, grid) returns an estimate of z0 based on
%   the Smith method but with an obstacle definition used in Chambers (2020).
%
%   Chambers(x,grid) accepts 'x' as a position-array (in meters) and 
%   'grid' as surface elevations which will be linearly detrended. 
%
%   Written by Armin Dachauer, Msc Student, Atmospheric and Climate
%   Science, ETH Zurich.
%   Reference: Chambers, J. R., M. W. Smith, D. J. Quincey, J. L. Carrivick, A. N. Ross, and M. R. James, 2020: Glacial Aerodynamic Roughness Estimates: Uncertainty, Sensitivity, and Precision in Field Measurements. Journal of Geophysical Research: Earth Surface, 125 (2), 1-9, doi:10.1029/2019JF005167.


%Initialize parameters
rs_x = size(grid,1);   
rs_y = size(grid,2);
s = NaN(rs_x,1);
h = NaN(rs_x,1);
val = 0;
dc = 0.5;
cell_res = x(2)-x(1);

%Calculation
for ii = 1:rs_x
    z = grid(ii,:);
    %linear detrending for each row
    z = z(~isnan(z));  %delete NaN's in row
    norm_z = detrend(z);  
    norm_z(norm_z <= 0) = NaN;  
    for ij = 2:length(norm_z)
        if ~isempty(z) && norm_z(ij) > norm_z(ij-1)
            val = val + (norm_z(ij) - norm_z(ij-1));
        end
    end
    s(ii) = val*cell_res;
    val = 0;
    h(ii) = 2*nanstd(norm_z);
end
s2 = sum(s(:));
S = rs_x*rs_y *cell_res*cell_res;
h_star = nanmean(h(:));
z0 = dc * h_star * s2 / S;   %only 1 value per DEM grid





