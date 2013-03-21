% PLOTTRAINING
%script to plot annotations on the training images. It also writes the a
%directory 'gt' which contains images overlayed with the annotations.

%% Copyright by- RIA team@IIIT-Hyderabad


ptsdir = 'trngpts';
if ~exist(ptsdir,'dir')
  ptsdir=uigetfile('.','Select the location of the points-files');
  if ~ptsdir
    disp('No location specified...Exiting');
    return
  end
end
ptsfiles=dir([ptsdir filesep '*.txt']);

imgsdir='training';
if ~exist(imgsdir,'dir')
  imgsdir=uigetfile('.','Select the training images folder');
  if ~imgsdir
    disp('No location specified...Exiting');
    return
  end
end

if ~exist([imgsdir filesep 'gt'])
  mkdir([imgsdir filesep 'gt']);
  disp(['created output directory ' imgsdir filesep 'gt']);
end
warning off;
disp('Press any key to view next image');
disp(' showing image...:')

for i=1:numel(ptsfiles)
  
  disp(num2str(i))
  
  name=ptsfiles(i).name;
  dots=find(name=='.');
  imgname=name(1:dots(2)-1);
  
  im=imread([imgsdir filesep imgname]);
  
  fp=fopen([ptsdir filesep name]);
  marks=fgets(fp);
  marks=eval(marks);
  for mno=1:size(marks,1)
    rad=marks(mno,3)+5;
    x=marks(mno,1);
    y=marks(mno,2);
    
    im(y-rad,x-rad:x+rad,1:3)=0;
    im(y-rad,x-rad:x+rad,2)=255;
    
    im(y+rad,x-rad:x+rad,1:3)=0;
    im(y+rad,x-rad:x+rad,2)=255;
    
    im(y-rad:y+rad,x-rad,1:3)=0;
    im(y-rad:y+rad,x-rad,2)=255;
    
    im(y-rad:y+rad,x+rad,1:3)=0;
    im(y-rad:y+rad,x+rad,2)=255;
  end
  imshow(im),title([num2str(i) ':' imgname]);
  imwrite(im,[imgsdir filesep 'gt' filesep imgname '.tif']);
  set(gcf,'position',[0 50 800 600]) 

  pause;
end
disp(['Copied displayed images to ' imgsdir filesep 'gt']);