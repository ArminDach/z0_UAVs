function g = frot(grid,nr)
%Grid rotation
%   [g1,g2,g3,g4] = rot(grid) returns rotations of the input data 'grid'.  
%
%  grid is the input raster that should be rotated. 'nr' is the required
%  amount of rotation in 90°steps. 
%  g1(nr = 1) is the original input dataset. g2 (2) is rotated 90° clockwise, g3 (3) is 
%  rotated 180° and g4 (4) is rotated 270° clockwise. 
%
%   Written by Armin Dachauer, Msc Student, Atmospheric and Climate
%   Science, ETH Zurich.


% x = size(grid,1);
% y = size(grid,2);

if nr == 1
    g = grid;
elseif nr == 2
    g = rot90(grid,3); 
elseif nr == 3
    g = rot90(grid,2);
elseif nr == 4
    g = rot90(grid,1);
end

