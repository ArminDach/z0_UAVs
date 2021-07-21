function [T] = ftable(z0_all_grd)

%ftable builds a table of the mean, median, std, and IQR of the input 
% z0-values of the whole DEM for all methods and wind directions
%
%   [T] = ftable(z0_all_grd, method, ws) returns a table T.
%
%   z0_all_grd is a matrix m-by-n where m is the z0 values of each sub-DEM 
%   and n the amount of layers (e.g. 5 methods times 4 cardinal wind
%   directions = 20).
%
%   Written by Armin Dachauer, Msc Student, Atmospheric and Climate
%   Science, ETH Zurich.


%Initialization
mean_up = NaN(5,1);
median_up = NaN(5,1);
std_up = NaN(5,1);
IQR_up = NaN(5,1);
mean_dw = NaN(5,1);
median_dw = NaN(5,1);
std_dw = NaN(5,1);
IQR_dw = NaN(5,1);
mean_ltr = NaN(5,1);
median_ltr = NaN(5,1);
std_ltr = NaN(5,1);
IQR_ltr = NaN(5,1);
mean_rtl = NaN(5,1);
median_rtl = NaN(5,1);
std_rtl = NaN(5,1);
IQR_rtl = NaN(5,1);
mean_av = NaN(5,1);
median_av = NaN(5,1);
std_av = NaN(5,1);
IQR_av = NaN(5,1);
    
    
    

%Calculation

methods = {'Smith', 'Chambers', 'Fitzpatrick', 'Munro', 'Lettau'};
for ii = 1:5
    ij = (ii*4)-3;
    mean_up(ii,:) = round(nanmean(z0_all_grd(:,ij+3)),3);
    median_up(ii,:) = round(nanmedian(z0_all_grd(:,ij+3)),3);
    std_up(ii,:) = round(nanstd(z0_all_grd(:,ij+3)),3);
    IQR_up(ii,:) = round(iqr(z0_all_grd(:,ij+3)),3);
    mean_dw(ii,:) = round(nanmean(z0_all_grd(:,ij+1)),3);
    median_dw(ii,:) = round(nanmedian(z0_all_grd(:,ij+1)),3);
    std_dw(ii,:) =round(nanstd(z0_all_grd(:,ij+1)),3);
    IQR_dw(ii,:) =round(iqr(z0_all_grd(:,ij+1)),3);
    mean_ltr(ii,:) = round(nanmean(z0_all_grd(:,ij+2)),3);
    median_ltr(ii,:) = round(nanmedian(z0_all_grd(:,ij+2)),3);
    std_ltr(ii,:) =round(nanstd(z0_all_grd(:,ij+2)),3);
    IQR_ltr(ii,:) =round(iqr(z0_all_grd(:,ij+2)),3);
    mean_rtl(ii,:) = round(nanmean(z0_all_grd(:,ij)),3);
    median_rtl(ii,:) = round(nanmedian(z0_all_grd(:,ij)),3);
    std_rtl(ii,:) =round(nanstd(z0_all_grd(:,ij)),3);
    IQR_rtl(ii,:) =round(iqr(z0_all_grd(:,ij)),3);
    mean_av(ii,:) = round(nanmean(z0_all_grd(:,ij:ij+3), 'all'),3);
    median_av(ii,:) = round(nanmedian(z0_all_grd(:,ij:ij+3), 'all'),3);
    std_av(ii,:) =round(std(z0_all_grd(:,ij:ij+3), 0,'all', 'omitnan'),3);
    IQR_av(ii,:) =round(iqr(z0_all_grd(:,ij:ij+3), 'all'),3);
end

up_glacier = table(mean_up, median_up, std_up, IQR_up);
down_glacier = table(mean_dw, median_dw, std_dw, IQR_dw);
cross_ltr = table(mean_ltr, median_ltr, std_ltr, IQR_ltr);
cross_rtl = table(mean_rtl, median_rtl, std_rtl, IQR_rtl);
average = table(mean_av, median_av, std_av, IQR_av);

T = table(up_glacier, down_glacier, cross_ltr, cross_rtl,average,'RowNames',methods);


