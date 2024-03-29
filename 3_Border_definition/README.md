This module allows to remove the pleura from the whole sample. It is based on a reduction of the sample ROI at a defined distance over a binary mask (e.g., output of module 2b).

Briefly, the image is duplicated, and the user is invited to repair potential breaks in the sample. Then, the pleura thickness is set by a defined distance from the border of the sample. Finally, a visualization is assembled.

Output consists of: (1) mask of ROI, (2) overlay of ROI over original mask, (3) ROI file, and (4) settings (input file name and pleura thickness).
