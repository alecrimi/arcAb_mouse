function plaque_region_count(fname,fname_atlas_lables,flag_erosion, conservative_adpthresh, remove_large_areas)

%Parameters
%n_substacks = 500;
%fname  = 'old_left_scaled.tif';%'left_c.tif';
info = imfinfo(fname);
num_images =  numel(info);
%fname_atlas_lables = 'revert\result.tif';%'result_atlas.tif ';
info2 = imfinfo(fname_atlas);
grouped_region = xlsread('regions_columns.xls');
[ sub, roi ] = size(grouped_region);
grouped_region(isnan(grouped_region))=0;
%res = zeros(floor(num_images/n_substacks),roi);
res = zeros(1,roi); %number of plaques per region (final result)
ROI_vol = zeros(1,roi); % how big is each region (in voxels/pixels)
se = offsetstrel('ball',4,4); %Erosion element in case of need to separate the ROIs
max_area = 150; %Plaques can be of a maximum number of pixels otherwise they are artefacts

%  Load data
temp = imread(fname);
[r,c] = size(temp);
volume = zeros(r,c,n_substacks,'uint16');
reg_atlas_lables = zeros(r,c,n_substacks,'uint16');

count = 1;
for k = 1     :    num_images
        volume(:,:,count ) = (imread(fname, k)); %imadjust
        count = count +1;
end
count = 1;
for k = 1     :    num_images
        reg_atlas_lables(:,:,count ) = (imread(fname_atlas_lables, k)); %imadjust
        count = count +1;
end

% For each substack
% Use low-level File I/O to read the file
%fp = fopen(fname , 'rb'); 
%fp2 = fopen(fname_atlas , 'rb'); 
% The StripOffsets field provides the offset to the first strip. Based on
% the INFO for this file, each image consists of 1 strip.
%fseek(fp, info.StripOffsets, 'bof');
%fseek(fp2, info2.StripOffsets, 'bof');

%for k = 1:  n_substacks:  num_images - n_substacks
%k
%{
    for jj = 1 : n_substacks
        tmp = fread(fp, [info.Width info.Height], 'uint16', 0, 'ieee-be')'; 
        %tmp = imread(fname, k + jj -1 );
        A(:,:,jj) = tmp(1:r,1:c);%imread(fname, k);
        reg_atlas(:,:,jj) = fread(fp2, [info2.Width info2.Height], 'uint16', 0, 'ieee-be')'; % imread(fname_atlas, k);
    end
    %}
    %reg_atlas = reg_atlas - 32768; %Adjust from imagej values
    % Derek Bradley & Gerhard Roth (2005) Adaptive Thresholding
    % Its more conservative way (less foreground) can be set by a parameter or by forcing to use the max
    %Segment according to global threshold automatically
    T = adaptthresh(volume);       
    if (conservative_adpthresh)
       bw=imbinarize(volume,max(max(max(T))));
    else
       bw=imbinarize(volume, T );
    end
    
    if(remove_large_areas)
      BW2 = bwareaopen(bw, max_area);
      bw = bw - BW2;
    end
    saveastiff(uint8(bw), [ 'segmentation.tif']);
    
    %Create mask according to region
    for ll = 1  :     roi
        ll
        mask = zeros(r,c,n_substacks,'uint16');
        this_roi = grouped_region(:,ll);
        this_roi(this_roi==0) = [];

        for zz = 1 : length(this_roi)
            %zz
            indices = find( reg_atlas == this_roi(zz) ) ;
            [rr,cc,z] = ind2sub(size(reg_atlas),indices) ;
            
            for pp = 1 : length(rr)
                   mask(rr(pp),cc(pp),z(pp)) = 1;
            end
            
        end
    
    %    for tt = 1 : n_substacks
    %        mask(:,:,tt) = imerode( mask(:,:,tt),se);
    %    end
        
        layer = mask.* uint16(bw); 
        
        res(1,ll) = max(max(max(bwlabeln(layer))));
        ROI_vol(1,ll) = sum(sum(sum(mask)));
    end
%end
%fclose(fp); 
%fclose(fp2); 

save
