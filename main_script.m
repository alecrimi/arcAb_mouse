% Main script

fname = 'right_volume.tif'; % Name of the file scanned (ideally at 644nm)

fname_atlas_lables  = 'right_atlas_lables.tirf'; % Name of the volume containing the registered atlas ROI lables

flag_erosion = 0; % Flag stating 0 if no further erosion between the ROI has to be carried out.

conservative_adpthresh = 1; % Flag influencing the segmentation by adaptive threshold, 1 means less foreground (adviced)

remove_large_areas = 0; % Flag removing large objects which cannot be plaques but are rather artifacts.

plaque_region_count(fname,fname_atlas_lables,flag_erosion, conservative_adpthresh, remove_large_areas)
