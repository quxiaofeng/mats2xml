MATS2XML
===================

Convert mat files to a xml.

The model is given by the training images and xml file.

mats2xml
-------------------
function [] = mats2xml(srcDir, xmlFileName)

+ srcDir: the folder where all mat files are placed
+ xmlFileName: output xml file name

example:
    mats2xml( 'data', 'rocdata.xml');


__listfiles__ is called to get all mat files. 

Current Problems
-------------------

1. The comment cannot be placed before the root node.

2. When there is no annotation in a image, the image node will be self-closing. This is different with training xml. In training xml, even blank image is normal closing. 
