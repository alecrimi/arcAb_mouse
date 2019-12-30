Thi repo contains the matlab script to generate some of the results reported in Ni et al.

Initially the Allen Mouse Brain Atlas https://www.nature.com/articles/nature13186 is used to register lables to the brain volumes and then plaques are counted according to specific regions of the atlas.
The process is run separately per hemisphere. Initially the reference volume of the atlas is registered to the acquired volume in a 2-step process. Then the transformation used to obtain the registration is applied to the lables reference volume.

The registration is performed by using the tool Elastix http://elastix.isi.uu.nl/
The configuration for the registration is given into the 2 files: affine.txt and bspline.txt, which represent respectively the first and second step.

Being the regions of the atlas grouped hierarchically, we follow the hierarchy summarized into the file region_columns.xls

plaque_region_count.m is the script practically performing the threshold and counting the connected elements in specific rois.

saveastiff.m is a utility to save large TIF files for visual inspection (e.g. the plaque segentation). The script was originally developed by YoonOh Tak https://ch.mathworks.com/matlabcentral/fileexchange/35684-multipage-tiff-stack

left_results.csv and right_results.csv summarize the plaque count.
The used images are available on Figshares at the URL: 
