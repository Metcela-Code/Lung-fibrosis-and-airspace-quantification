This module allows to remove the physiological depositions of collagen around air ducts (i.e., peri-duct collagen deposition). It is based on an extension of the air ducts ROI (i.e., output of module 4) at a defined distance over a binary mask (e.g., output of module 2b).

Briefly, the image is duplicated, and the air ducts walls are set at a defined distance around the air ducts. A visualization is assembled.

Output consists of: (1) overlay #1 (visualization of air ducts walls as an extended ROI), (2) overlay #2 (visualization of air ducts walls and air ducts), (3) ROI file, and (4) settings (input file name and air ducts walls thickness). 1
