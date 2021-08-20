%This script extracts EVP data from noah NC4 files and export to .xls

ncvars =  {'SOILM'}; %variable to be extracted
projectdir = pwd; %set to script's directory

dinfo = dir(fullfile(projectdir, '*.nc4') ); %list w/ .nc4 extension
num_files = length(dinfo); %number of files
filenames = fullfile(projectdir, {dinfo.name} ); %list of file names

EVP = cell(num_files, 1); %initiate EVP cell
EVPmean = cell(num_files, 1); %initiate EVP cell
Year = cell(num_files, 1); %initiate year cell

for H = 1:num_files %extract yyyymm from filenames
    year = extractBetween(filenames{1,H},"M.A",".002");
    Year{H} = str2double(year);
end
clear H year

for I = 1:num_files %ncread each of the .nc4 in directory
  this_file = filenames{I}; 
  EVP{I} = ncread(this_file, ncvars{1}); 
end
clear num_files projectdir this_file

for J = 1:I %convert each NaN to = 0 for mean
EVP{J,1}(isnan(EVP{J,1}))=0;
end
clear J

for K = 1:I %take mean over the entire area and set to EVPmean
    EVPmean{K} = mean(mean(vertcat(EVP{K,1})));
end
clear K

output = cat(2,Year,EVPmean); %concatenate year and evp
writecell(output,'SOILM.xls'); %output to EVP.xls

clear I filenames ncvars Year dinfo