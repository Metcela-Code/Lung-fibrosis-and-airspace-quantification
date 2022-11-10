This module allows to detect the pathological depositions of collagen. It is based on a double thresholding over the green channel (e.g., output of modules 6a/b).

Briefly, the image is scaled and duplicated. The channel of interest is extracted, and a double thresholding is applied. All selected particles are described (i.e., area and perimeter), and a visualization is assembled.

Output consists of: (1) mask of ROI, (2) overlay of ROI over the parenchyma image, (3) ROI file, (4) measurements (area and perimeter) of all selected particles, (5) summary of measurements (area and perimeter) of all selected particles, and (6) settings (input file name, scale, lower threshold, upper threshold, and number of selected particles).
