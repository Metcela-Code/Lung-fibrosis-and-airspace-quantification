This module allows to detect the sample and remove the background. It is based on a double thresholding over the blue channel.

Briefly, the image is scaled and duplicated. The channel of interest is extracted and a double thresholding is applied. All particles selected are described (i.e., area and perimeter) and a visualization is assembled.

Output consists of: (1) mask of ROI, (2) overlay of ROI over original image, (3) ROI file, (4) measurements (area and perimeter) of all selected particles, (5) summary of measurements (area and perimeter) of all selected particles, and (6) settings (input file name, scale, lower threshold, upper threshold, and number of particles selected).
