function [] = mats2xml(srcDir, xmlFileName)
%mats2xml Write mats data to an xml file
%
%
% Example:
%   tic;
%   mats2xml( 'data', 'rocdata.xml');
%   toc;
%% Load mats
matFullPaths = listfiles( srcDir, 'mat', 'run', 'all' );
pathRegex = '.*\\';
matNames = regexprep(matFullPaths, pathRegex, '');
extRegex = '\.[^.]+$';
matNames = regexprep(matNames, extRegex, '.jpg');

%% Create a sample XML document.
docNode = com.mathworks.xml.XMLUtils.createDocument('set');
docRootNode = docNode.getDocumentElement;
comment = ['\n' ... 
'    annotations-consensus.xml\n'... 
'\n'...
'    This dataset of 50 images with microaneurysms and or hemorrhages\n'... 
'    (named image0_training.jpg to image50_training.jpg)\n'...
'    and the corresponding retinal specialist annotations are copyrighted material owned by the University of Iowa.\n'...
'\n'...
'    The 50 images are from patients with diabetes without known diabetic retinopathy at the moment\n'...
'    of photography and represent a random sample of unique patients with ''red lesions'' from a large\n'...
'    (> 10,000 patients) diabetic retinopathy screening program.\n'...
'    The images were taken with Topcon NW 100, NW 200 or Canon CR5-45NM ''non-mydriatic'' cameras\n'...
'    at their native resolution and compression settings.\n'...
'    The retinal specialist annotations were obtained from a combination of three ophthalmologists with\n'...
'    retinal fellowship training.\n'...
'\n'...
'    The use of these images and the annotations is permitted according to the rules set forward\n'...
'    at roc.healthcare.uiowa.edu. Please look at this website for more details \n'...
'    or contact michael-abramoff at uiowa.edu.\n'...
'\n'...
'    Michael Abramoff\n'...
'    There is an "annotations-per-image" per image, and multiple "annotation" s per image.\n'...
];
docNode.appendChild(docNode.createComment(sprintf(comment)));
for iImage=1:size(matFullPaths,1) % image
    picElement = docNode.createElement('annotations-per-image');
    picElement.setAttribute('imagename',matNames{iImage});
    docRootNode.appendChild(picElement);
    load(matFullPaths{iImage});
    if 0 == num
        continue;
    end
    for iAnnotation = 1:num % annotation
        annotationElement = docNode.createElement('annotation');
        picElement.appendChild(annotationElement);
        
        % mark
        markElement = docNode.createElement('mark');
        markElement.setAttribute('x',sprintf('%i',centroids(iAnnotation,1)));
        markElement.setAttribute('y',sprintf('%i',centroids(iAnnotation,2)));
        annotationElement.appendChild(markElement);
        
        for itemp=1 % radius % just for indent
            radiusElement = docNode.createElement('radius');
            markElement.appendChild(radiusElement);
            markElement.appendChild...
                (docNode.createTextNode(sprintf('%i',radius(iAnnotation))));
        end
        
        % lesion
        lesionElement = docNode.createElement('lesion');
        lesionElement.appendChild...
            (docNode.createTextNode('microaneurysm'));
        annotationElement.appendChild(lesionElement);
        
        % probability
        probabilityElement = docNode.createElement('probability');
        probabilityElement.appendChild...
            (docNode.createTextNode(sprintf('%1.1f',probability(iAnnotation))));
        annotationElement.appendChild(probabilityElement);
       
    end % annotation
    clear('num','centroids','radius','probability');
end % image


% Save the sample XML document.
xmlwrite(xmlFileName,docNode);
edit(xmlFileName);
end
