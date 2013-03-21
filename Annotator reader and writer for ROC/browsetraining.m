%BROWSETRAINING
% This script can be used to browse the annotated retinal images of the ROC
% (http://roc.healthcare.uiowa.edu) training data.
%
% This script Written by Retinal Image Analysis Team, IIIT-Hyderabad, India
% It converts the annotations present in XML format to a
% matlab-friendly matrix.

maketfiles;
% For each image in the training set, a matrix is created, in which
% each row has 4 elements : 
% [ annot_x, annot_y, annot_radius, annot_probability]
% this matrix is stored in a text file (per image) in directory 'trngpts', or
% user-specified location.

plottraining;
% reads the matrix for each training image, and displays the
% annotation as a green box. The displayed image is also saved in
% directory 'training/gt'