This module allows to remove false positive particles in the background which cannot be filtered by size. It is based on a manual deletion of objects over a binary mask (e.g., output of module 2a).

Briefly, the image is duplicated, and background particles are deleted by the user. All remaining particles are described (i.e., area and perimeter), and a visualization is assembled.

Output consists of: (1) mask of ROI, (2) overlay of ROI over original mask, (3) ROI file, (4) measurements (area and perimeter) of all remaining particles, (5) summary of measurements (area and perimeter) of all remaining particles, and (6) settings (input file name and number of remaining particles).
