%% Master Thesis: "Aerodynamic Surface Roughness of Crevassed Tidewater Glaciers from UAV Mapping"
%Author: Armin Dachauer
%Msc Student, Atmospheric and Climate Science, ETH Zürich.
%Date: May - October 2020

clear all

%Import DEM data
filename = '....file.tif...';
glacier = 'MB20';
[DEM, DEM_R] = geotiffread(filename);  
info = geotiffinfo(filename);

%if raw DEM
DEM(DEM == DEM(1,1)) = NaN;   
DEM = double(DEM);
DEM_orig = DEM;

% Plot DEM
% [x,y] = pixcenters(DEM_R, size(DEM));   %x,y-coordinates
% figure(2)
% imagesc(x,y,DEM,'AlphaData',~isnan(DEM));
% xlabel('Easting (m)')
% ylabel('Northing (m)')
% zlabel('Elevation in meters')
% set(gca,'YDir','normal')
% set(gcf,'color','w'); %white background
% c = colorbar;
% ylabel(c,'Elevation (m)');
% ax = gca;
% ax.FontSize = 12;
% ax.XRuler.Exponent = 0;
% ax.YRuler.Exponent = 0;
% ytickformat(ax, '%d');
% xlim([487500 489850]);
% ylim([8634200 8636500]);

%% Data Preparation
%Rotate image
angle = 80; %in degrees
DEM = imrotate(DEM_orig,angle, 'bicubic','crop');
if all(DEM_orig ~=0)
    DEM(DEM == 0) = NaN; 
end

%Cut out the sea
DEM(DEM<1) = NaN;  

%Remove all rows&columns with only NaN
DEM = DEM(~all(isnan(DEM),2),:); % for nan - rows
DEM = DEM(:,~all(isnan(DEM)));   % for nan - columns

%flip Y-ayis -> mirrored downwards
DEM = flipud(DEM);

%% z0 Calculation

%%%%%%%%%%%%%%%%%
grdsz = 50;   %Grid Size in m
%%%%%%%%%%%%%%%%%

%x,y,z of rotated DEM
cellwidth_x = DEM_R.CellExtentInWorldX;
cellwidth_y = DEM_R.CellExtentInWorldX;
x=zeros(1, size(DEM,1));
y=zeros(1, size(DEM,2));
for ii = 1:size(DEM,1)
    x(ii) = (ii-1)*cellwidth_x;   %only use x,y-coord for original data (no rotation, clip, etc.)
end
for ii = 1:size(DEM,2)
    y(ii) = (ii-1)*cellwidth_y; 
end
z = DEM - nanmin(nanmin(DEM));

%Parameter Initialization
rs_x = size(DEM,1);
rs_y = size(DEM,2);
cellwidth = DEM_R.CellExtentInWorldX;
gs = round(grdsz / cellwidth);  %# of pixel needed for chosen grid size
z0_sm_m = NaN(rs_x,rs_y,4);
z0_chmbrs_m = NaN(rs_x,rs_y,4);
z0_fp_m = NaN(rs_x,rs_y,4);
z0_lettau_m = NaN(rs_x,rs_y,4);
z0_munro_m = NaN(rs_x,rs_y,4);
z0_sm_std = NaN(rs_x,rs_y,4);
z0_qncy_std = NaN(rs_x,rs_y,4);
nr_dem = round((rs_x-1-gs)/gs) * round((rs_y-1-gs)/gs);
z0_all_grd = NaN(nr_dem,5*4);
iii = 1;

% Model Calculation
for ik = 1:gs:(rs_x-1-gs)   %-gs to make sure that last grid is not to big.
    im = ik:(ik+gs-1);
    for ip = 1:gs:(rs_y-1-gs)  
        io = ip:(ip+gs-1);
        grid_orig = z(im,io);
        x2 = x(1,im);
        
        %Calculation
        if(sum(sum(isnan(grid_orig)))<0.5*numel(grid_orig)) %only calculate if more than 50% non-NaN  
            for ix = 1:4  %4 wind directions
                grid = frot(grid_orig,ix);
                z0_sm = Smith(x2, grid);
                z0_chmbrs = Chambers(x2, grid);
                z0_fp = Fitzpatrick(x2, grid);
                z0_munro = Munro(x2, grid);
                z0_lettau = Lettau(x2, grid);
                                               
                z0_sm_m(im,io, ix) = nanmean(z0_sm);
                z0_chmbrs_m(im,io, ix) = nanmean(z0_chmbrs);
                z0_fp_m(im,io, ix) = nanmean(z0_fp);
                z0_munro_m(im,io, ix) = nanmean(z0_munro);
                z0_lettau_m(im,io, ix) = nanmean(z0_lettau);
            end
            iii = iii+1;
        end
    end    
end
  
%Prepare Data for Boxplot -> grid
for id = 1:4
    sm_grd = z0_sm_m(:,:,id);
    chmbrs_grd = z0_chmbrs_m(:,:,id);
    fp_grd = z0_fp_m(:,:,id);
    mnr_grd = z0_munro_m(:,:,id);
    ltt_grd = z0_lettau_m(:,:,id);
    
    lg = 1:length(unique(sm_grd(~isnan(sm_grd))));
    z0_all_grd(lg,id) = unique(sm_grd(~isnan(sm_grd)));  %every value only once
    z0_all_grd(lg,id+4) = unique(chmbrs_grd(~isnan(chmbrs_grd)));
    z0_all_grd(1:length(unique(fp_grd(~isnan(fp_grd)))),id+8) = unique(fp_grd(~isnan(fp_grd)));
    z0_all_grd(lg,id+12) = unique(mnr_grd(~isnan(mnr_grd)));
    z0_all_grd(lg,id+16) = unique(ltt_grd(~isnan(ltt_grd))); 
end

%%  Save and plot
path_save_results = '.... add file location...';
save([path_save_results glacier '_' num2str(grdsz) 'mgrid_' datestr(datenum(date),'ddmmyy')],'z0_all_grd')

%% Plot z0 on the map
for iu = 4
wd = iu; %wind direction
sv = 4; %not save = 1, save = 2, with hillshade = 3, save hillshade = 4
fplotmap(x,y,DEM,z0_sm_m(:,:,wd),z0_chmbrs_m(:,:,wd),z0_fp_m(:,:,wd),z0_munro_m(:,:,wd),z0_lettau_m(:,:,wd), sv, glacier, wd, grdsz);
end
%% Boxplot Graph
fboxplot(z0_all_grd)

%% Table values mean z0
T = ftable(z0_all_grd)

%%  Write tables to read in Excel
name = T;
var = name.Variables
path = '...add file location...';
writetable(var, path, 'WriteRowNames',true)

