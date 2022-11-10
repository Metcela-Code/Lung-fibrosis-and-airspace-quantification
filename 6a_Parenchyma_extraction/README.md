This module allows to extract the parenchyma from the original image. It is based on the deletion of the ROI defined in the previous steps (i.e., background, pleura, and air ducts walls).

Briefly, the original image is duplicated, and undesirable regions are deleted.

Output consists of: (1) RGB image of the parenchyma, (2) measurements (area and perimeter) of the parenchyma, (3) ROI file, and (4) settings (input file name and scale). 1
