function maketfiles()
%MAKETFILES
% script to convert annotations XML data to matlab-friendly matrix
% For each training image, a matrix is created, 
% where each row is [ annot_x, annot_y, annot_radius,
% annot_probability]
%  The matrix is written to a text file (<imagename>.txt) in folder
%  './trngpts' if exists (or user-specified location)

addpath xmltree
training = [];
if exist('training.mat','file')
  load training.mat
else
  trngfile='training/annotations-consensus-ma-only.xml';
  if ~exist(trngfile,'file')
    [file,pth]=uigetfile('*.xml;','Select Annotations XML file');
    if ~file
      disp('Annotations file not specified...Exiting');
      return
    end
    trngfile=[pth filesep file];
  end
              
  training=xmltree(trngfile);
end

outdir='trngpts';
if ~exist(outdir,'dir')
  outdir=uigetdir('.','Select output directory for points');
  if ~outdir
    disp('output directory not specified...Exiting');
    return
  end
  
end

rnode=root(training);

cnodes=children(training,rnode);

nchildren=numel(cnodes);


for i=1:nchildren
  
  nodeno = cnodes(i);
  node = get(training, nodeno);
  nattrs=numel(node.attributes);
  filename='';
  for atr=1:nattrs
    if strcmp(node.attributes{atr}.key,'imagename')
      filename=node.attributes{atr}.val;
      break
    end
  end
  marks=readannot(training,nodeno);
  fp=fopen([outdir filesep filename '.txt'],'wt');
  fprintf(fp,mat2str(marks));
  fclose(fp);
end
disp(['dumped ' num2str(nchildren) ' points-files in ' outdir]);
  
%%%%%%%%%%%%%%%%%%%
  
function marks=readannot(tree,nodeno)
marks=[];
annots = children(tree,nodeno);
for ann=1:numel(annots)
  anndata = children(tree,annots(ann));
  mark=zeros(1,4);
  for anmem=1:numel(anndata)
    memnode = get(tree,anndata(anmem));
    if strcmp(memnode.name,'mark')
      coordatrs=memnode.attributes;
      for i=1:numel(coordatrs)
        if strcmp(coordatrs{i}.key,'x')
          mark(1)=double(str2num(coordatrs{i}.val));
        elseif strcmp(coordatrs{i}.key,'y')
          mark(2)=double(str2num(coordatrs{i}.val));
        end
      end
      radnodeno=children(tree,children(tree, ...
                                           anndata(anmem)));
      rad=get(tree,radnodeno(1),'value');
      mark(3)=double(str2num(rad));
      
    elseif strcmp(memnode.name,'probability')
      
      probnode=children(tree,anndata(anmem));
      mark(4)=double(str2num(get(tree,probnode,'value')));
      
    end
  end
  marks(end+1,1:4)=mark;
end
