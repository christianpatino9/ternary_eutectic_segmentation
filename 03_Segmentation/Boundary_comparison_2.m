function Boundary_comparison_2(FolderPath,File,PixSeparated,m,n)

BW = imbinarize(PixSeparated(:,:,2));
BW2 = imbinarize(PixSeparated(:,:,3));
[boundaries] = bwboundaries(BW);
[boundaries2] = bwboundaries(BW2);

Image_8bit = imread(char(strcat(FolderPath,'/',File(1),'.',File(2))));
Image_rgb=uint8(zeros(m,n,3));
for i=1:3
    Image_rgb(:,:,i)=Image_8bit(:,:);
end    

for i = 1:length(boundaries)
  boundary = boundaries{i};
  for j=1:length(boundary)
    Image_rgb(boundary(j,1),boundary(j,2),1)=0;      
    Image_rgb(boundary(j,1),boundary(j,2),2)=255;    
    Image_rgb(boundary(j,1),boundary(j,2),3)=0;
  end    
end

for i = 1:length(boundaries2)
  boundary = boundaries2{i};
  for j=1:length(boundary)
    Image_rgb(boundary(j,1),boundary(j,2),1)=0;      
    Image_rgb(boundary(j,1),boundary(j,2),2)=0;    
    Image_rgb(boundary(j,1),boundary(j,2),3)=255;
  end    
end

imwrite(Image_rgb,char(strcat(FolderPath,'/',File(1),'_outline.tif')))