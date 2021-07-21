function [] = fplotmap(y,x,DEM,z0_sm, z0_ch,z0_fp, z0_qc, z0_lt, sv, glacier, wd, grdsz)

%Function to plot and save z0 values of the whole DEM.
%   [] = fplotmap(y,x,DEM,z0_sm, z0_ch,z0_fp, z0_qc, z0_lt, sv, glacier, wd, grdsz)
%   returns a map of the z0 values of the investigated glacier DEM. 'x' and
%   'y' are the location-arrays with the relativ location of the DEM
%   pixels. 'z0_sm' to 'z0_lt' are the input z0 values for each Method (Smith, 
%   Chambers, Fitzpatrick, Munro and Lettau). 'sv' presents the option to 
%   save (sv = 2) or not save (sv = 1) the figures and the option to add a 
%   hillshade sublayer (sv = 3) which again can be saved (sv = 4).
%   'glacier' represents the name of the glacier, 'wd' is the wind
%   direction and 'grdsz' the according grid size of the subarea. 
%
%   Written by Armin Dachauer, Msc Student, Atmospheric and Climate
%   Science, ETH Zurich.

rs_y = size(z0_sm,1);
rs_x = size(z0_sm,2);
cellwidth = y(2)-y(1);
gs = round(grdsz / cellwidth);  %# of pixel needed for gridsize


mapcolor = [0,0,0;hot(256)]; 
labels = {'z0_sm'; 'z0_ch';'z0_fp';'z0_qc';'z0_lt'};
path_save_graph = '...file location...';

for ij =1:5
figure(ij);
z0_grid1 = eval(labels{ij});  
%cut NaN values
y_nan = gs*floor(rs_y/gs);
x_nan = gs*floor(rs_x/gs);
DEM2 = DEM(1:y_nan,1:x_nan);  

z0_grid2 = flipud(z0_grid1(1:y_nan, 1:x_nan));

if sv == 3 | sv == 4
    hill = hillshade(DEM2,y(1:y_nan),x(1:x_nan),'plotit');
    RGB1 = ind2rgb(uint8(hill),gray(256));
end

h2 = imagesc(x(1:x_nan),y(1:y_nan),flipud(z0_grid2)); 
hold on
if sv == 3 | sv == 4
    h1 = imagesc(x(1:x_nan),y(1:y_nan),RGB1);hold on  
    set(h1,'AlphaData',0.4*ones(size(DEM2))) 
end
axis equal tight
xlabel('x (m)');ylabel('y (m)')
set(gca,'ColorScale','log','Ydir','normal') 
set(gcf,'color','w'); 
set(gcf,'outerposition',get(0,'ScreenSize'))
c = colorbar; 
ylabel(c,'z_0 (m)');
colormap(mapcolor);
ax = gca; 
ax.FontSize = 12;
ax.TickDir = 'out';
caxis([0.0001 10])

if sv == 2 
    saveas(gcf,[path_save_graph glacier '_' num2str(grdsz) 'mgrid_' labels{ij} '_' 'wd' num2str(wd) '_' datestr(datenum(date),'ddmmyy') '.png'])
elseif sv == 4
    saveas(gcf,[path_save_graph glacier '_' num2str(grdsz) 'mgrid_' labels{ij} '_' 'wd' num2str(wd) '_' 'hs' '_' datestr(datenum(date),'ddmmyy') '.png'])
end
end
