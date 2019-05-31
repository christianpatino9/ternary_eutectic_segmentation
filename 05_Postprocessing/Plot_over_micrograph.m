function Plot_over_micrograph(Matrix_Val,PixSeparated,m,n,FolderPath,File,min_Val,max_Val)

k=3;
for i = 1:3
  PixSeparated_Lab(:,:,i)=bwlabel(imclearborder(PixSeparated(:,:,i),8),8);
end

Image_8bit = imread(char(strcat(FolderPath,'\',File(1),'.',File(2))));
Image_rgb=uint8(zeros(m,n,3));
for i=1:3
    Image_rgb(:,:,i)=Image_8bit(:,:);
end    

% max_Val=max(max(Matrix_Val));
% min_Val=min(min(Matrix_Val));

slope=(0-0.75)/(max_Val-min_Val);
y_value=0.75-slope*min_Val;

for i=1:m
    for j=1:n
        if PixSeparated_Lab(i,j,k)>0
            Val=Matrix_Val(k,PixSeparated_Lab(i,j,k));
            if Val>=min_Val && Val<=max_Val
                h=Val*slope+y_value;
                if h<0
                    h=0;
                end 
                if h>1
                    h=1;
                end    
                rgb_val=hsv2rgb([h,1.0,1.0]);
                Image_rgb(i,j,1)=rgb_val(1)*255;
                Image_rgb(i,j,2)=rgb_val(2)*255;
                Image_rgb(i,j,3)=rgb_val(3)*255;
            end
        end
    end    
end

imwrite(uint8(Image_rgb),char(strcat(FolderPath,'\',File(1),'_overlayed.tif')))
