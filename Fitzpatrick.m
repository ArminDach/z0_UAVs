function z0 = Fitzpatrick(x, grid)
%Surface roughness height estimation.
%   z0 = Fitzpatrick(x, grid) returns an estimate of z0 based on
%   a method applied by Fitzpatrick(2019).  
%
%   Fitzpatrick(x,grid) accepts 'x' as a position-array (in meters) and 
%   'grid' as surface elevations which will be linearly detrended. If 
%   the grid contains any NaN values, then it will not be linearly 
%   detrended but uses a smoothing function (sgolay filter). 
%
%   Written by Armin Dachauer, Msc Student, Atmospheric and Climate
%   Science, ETH Zurich.
%   Reference: Fitzpatrick, N., V. Radi¢, and B. Menounos, 2019: A multi-season investigation of glacier surface roughness lengths through in situ and remote observation. The Cryosphere, 13 (3), 1051-1071, doi:10.5194/tc-13-1051-2019.


%%%%%%%%%%
% s, S and z0 are determined in subgrid -> nanmean(z0) gives one value 
% per input DEM
% Detrending/Smoothing applied for whole input grid
%%%%%%%%%%

%Initialize parameters
cell_res = x(2)-x(1);
gs_1 = round(30/cell_res); %gridsize: RE is 30m
if ~mod(gs_1,2) == 0 %gs must be odd
    gs = gs_1;
else
    gs = gs_1 - 1;
end

ec = (gs-1)/2;    %empty_cells due to border effect -> e.g. 1 for 3x3 grid
dc = 0.5;  
rs_x = size(grid,1);   
rs_y = size(grid,2);
z0_grd = NaN(rs_x,rs_y);

%detrend
% if isnan(grid)  %if grid contains NaN -> smooth sgolay -> for frontal areas only
%     C = smoothdata(grid,'sgolay', rs_x, 'includenan');
%     grid_detr = grid - C;
%     fprintf('Fitzpatrick detrended with smoothing function\n');
% else
    grid1 = rot90(grid, 3); %detrending with matrix detrends each column separatley
    grid2 = detrend(grid1); %Thus grid is rotated 90° for detrending to make sure detrending happens row-wise (same as all the other methods)
    grid_detr = rot90(grid2, 1); %rotated back to usual.
%end


%Calculation
for ii = 1+ec:rs_x-ec
  for ij = 1+ec:rs_y-ec
      s=0;
      grid2 = grid_detr(ii-ec:ii+ec,ij-ec:ij+ec);
      for in = 1:gs
        z = grid2(in,:);
        val = (nanmax(z) - z(1)) *cell_res;
        s = val + s;
      end
      grid2(grid2<=0) = NaN;
      h_star = nanmean(grid2,'all');
      S = gs*gs *cell_res * cell_res;
      z0_grd(ii,ij) = dc * h_star * s / S;
  end
end
z0 = nanmean(z0_grd, 'all');



 
