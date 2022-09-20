This module allows to remove false positive particles from the selection. It is based on a size filter over a binary mask (e.g., output of module 1).

Briefly, the image is duplicated, and a size filter is applied. All particles selected are described (i.e., area and perimeter) and a visualization is assembled.

Output consists of: (1) mask of ROI, (2) overlay of ROI over original mask, (3) ROI file, (4) measurements (area and perimeter) of all selected particles, (5) summary of measurements (area and perimeter) of all selected particles, (6) settings (input file name, minimum particle size, maximum particle size, and number of particles selected).
