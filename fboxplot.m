function [] = fboxplot(z0_all_grd)

%Boxplot of the z0-values of the whole DEM for all methods and wind
%directions
%   [] = fboxplot(z0_all_grd) returns a figure boxplot.
%
%   z0_all_grd is a matrix m-by-n where m is the z0 values of each sub-DEM 
%   and n the amount of layers (e.g. 5 methods times 4 cardinal wind
%   directions = 20).
%
%   Written by Armin Dachauer, Msc Student, Atmospheric and Climate
%   Science, ETH Zurich.

nr_dem = size(z0_all_grd,1);
g1 = repmat([1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5],nr_dem,1);
g2 = repmat('abcdabcdabcdabcdabcd',nr_dem,1);
% reshape everything into columns
zv = z0_all_grd(:);
gp1 = g1(:);
gp2 = g2(:);
colrs = [0, 0.4470, 0.7410;0.8500, 0.3250, 0.0980;0.6350, 0.0780, 0.1840;0, 0.5, 0];

% White-Black
datlim = [0,1];
boxplot(zv , {gp1,gp2},'color', colrs,'factorgap',[5 0], 'DataLim', datlim,  'outliersize',0.00000001, 'boxstyle','filled')
hChildren = findall(gca,'Tag','Box');
hLegend = legend(hChildren([4,3,2,1]), {'cross-rtl', 'down-glacier', 'cross-ltr', 'up-glacier'}, 'Location', 'northwest');
legend boxoff  
h = findobj('YData',[ datlim(1) datlim(1)],'-or','YData',[datlim(2) datlim(2)]);
set(h,'Visible','off');
set(gca,'xtick',[2.5:5:23])
set(gca, 'Linewidth', .5, 'FontSize', 10)
set(gca,'xticklabel',{'Smith', 'Chambers','Fitzpatrick','Munro', 'Lettau'})
set(gcf,'color','w'); 
ylabel('z_0 (m)'); 
%title('Boxplot of z_0 for different wind direction and calculation methods')


