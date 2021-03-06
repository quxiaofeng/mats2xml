function writexml(varargin)
%WRITEXML
% This script reads lesion location from the text files of each images 
%(generated by the MA detection algorithm) and writes a single XML files
% in the current working directory. The generated XML file can be used to report the 
% algorithm's results to ROC. 

% writexml(optl_detectionsdir) create xml file from matlab annotation matrix 
% default detectionsdir='./detected';
% Copyright by- RIA team@IIIT-Hyderabad


detectionsdir='detected';
 

if nargin>0
  detectionsdir=varargin{1};
end

if ~exist(detectionsdir,'dir')
  detectionsdir=uigetdir('.','Select Detections location');
  if ~detectionsdir
    disp('No location selected...Exiting');
    return
  end
end

outfiles = dir('det_*');

majorver=1;
minorver=0;

for i=1:numel(outfiles)
  filename=outfiles(i).name;
  unds=find(filename=='_');
  dots=find(filename=='.');
  Mv = str2num(filename(unds(1)+1:dots(1)-1));
  mv = str2num(filename(dots(1)+1:dots(2)-1));
  if Mv > majorver
    majorver=Mv;
  end
  if mv > minorver
    minorver = mv;
  end
end
minorver = minorver+1;

fp = fopen(['det_' num2str(majorver) '.' num2str(minorver) ...
            '.xml'],'wt');
fprintf(fp,'<?xml version="1.0" encoding="utf-8"?>');
fprintf(fp,['\n<!-- Created: ' datestr(now) ' -->']); 
fprintf(fp,['\n<!--  Generated from specified directory -->']);
fprintf(fp,'\n<set>');

detections=dir([detectionsdir filesep '*.txt']);

for i=1:numel(detections)
  fn = detections(i).name;
  detfn = fopen([detectionsdir filesep fn]);
  detdata = fgets(detfn);
  detdata = eval(detdata);
  fclose(detfn);
  
  dots = find(fn=='.');
  imagename=fn(1:dots(end)-1);
  fprintf(fp,'\n\t<annotations-per-image  imagename="%s">',imagename);
  for pt=1:size(detdata,1)
    fprintf(fp, '\n\t\t<annotation>');
    fprintf(fp, '\n\t\t\t<mark x="%d" y="%d">',detdata(pt,1),detdata(pt,2));
    fprintf(fp, '\n\t\t\t\t<radius>%d</radius>',detdata(pt,3));
    fprintf(fp, '\n\t\t\t</mark>');
    fprintf(fp, '\n\t\t\t<lesion>microaneurysm</lesion>');
    fprintf(fp, '\n\t\t\t<probability>%.3f</probability>', ...
            detdata(pt,4));
    fprintf(fp, '\n\t\t</annotation>');
  end
  fprintf(fp,'\n\t</annotations-per-image>');
end
fprintf(fp,'\n</set>');
fclose(fp);
disp(['written xml file : det_' num2str(majorver) '.' num2str(minorver) ...
            '.xml']);


  