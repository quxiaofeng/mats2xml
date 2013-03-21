function [ images, labels ] = listfiles( srcDir, fileType, debug, onlyOne )
%listfiles List all files under srcDir recursively
%   List all 'fileType' files under 'srcDir' recursively. 'onlyOne'
%   enables to read only one file of one folder.
% Example:
%   tic;
%   [images,labels] = listfiles( 'E:\data\dks', 'png', 'run', 'all');
%   toc;

%% check args
switch nargin
    case 4
    case 3
        onlyOne = false;
    case 2
        onlyOne = false;
        debug = 'debug';
    case 1
        onlyOne = false;
        debug = 'debug';
        fileType = 'png';
    otherwise
        error('wrong arguments number');
end

% srcDir
if isdir(srcDir) == false
    error('dataset is not exist');
end

% fileType
switch fileType
    case 'png'
    case 'bmp'
    case 'jpg'
    case 'mat'
    otherwise
        error('unsupported image type(png, bmp, jpg)');
end

% debug
switch debug
    case 1
        debug = true;
    case 0
        debug = false;
    case true
        debug = true;
    case false
        debug = false;
    case 'debug'
        debug = true;
    case 'release'
        debug = false;
    case 'run'
        debug = false;
    case 'test'
        debug = false;
    otherwise
        error('wrong debugflag(1, true, ''debug'', ''test'', 0, false, ''release'', ''run'')');
end

% onlyOne
switch onlyOne
    case 1
        onlyOne = true;
    case 0
        onlyOne = false;
    case true
        onlyOne = true;
    case false
        onlyOne = false;
    case 'onlyOne'
        onlyOne = true;
    case 'all'
        onlyOne = false;
    otherwise
        error('wrong onlyOneFlag(1, true, ''onlyOne'', 0, false, ''all'')');
end

if debug
    disp(srcDir);
end

%% find images in subdirs
otherImages = [];
otherLabels = [];
subdirs  = dir(srcDir);
for iSubdir = 1 : size(subdirs,1)
    if isaFolder(srcDir, subdirs(iSubdir).name) == false
        continue;
    end
    subdirName = subdirs(iSubdir).name;
    fullSubdirName = fullfile(srcDir, subdirName);
    [subdirImages, subdirLabels]= listfiles( fullSubdirName, fileType, debug, onlyOne);
    if size(subdirImages,1) > 0
        otherImages = [otherImages; subdirImages];
        otherLabels = [otherLabels; subdirLabels];
    end
end

%% find images in current dir
subdirImages  = dir(fullfile(srcDir,['*.',fileType]));
if size(subdirImages,1) > 0
    if onlyOne
        nImages = 1;
    else
        nImages = size(subdirImages,1);
    end    
    tempNewImages = cell(nImages,1);
    tempNewLabels = cell(nImages,1);
    for iImages = 1:nImages
        tempImageName = subdirImages(iImages).name;
        tempNewImages{iImages} = fullfile(srcDir, tempImageName);
        tempNewLabels{iImages} = srcDir;
    end
    images = [tempNewImages; otherImages];
    labels = [tempNewLabels; otherLabels];
else
    images = otherImages;
    labels = otherLabels;
end

end

function [ result ] = isaFolder( srcDir, folderNameString )
%

if (~strcmp(folderNameString, '.')...
        && ~strcmp(folderNameString, '..')...
        && isdir(fullfile(srcDir,folderNameString)))
        result = true;
else 
    result = false;
end

end
