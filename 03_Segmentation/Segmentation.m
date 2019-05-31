function [PixSeparated] = Segmentation(I,m,n,Segmentation_split_x,Segmentation_split_y)

Quant=I;
if (Segmentation_split_x==1) && (Segmentation_split_y==1)
    Thresh = multithresh(I,2);
    Quant = imquantize(I,Thresh);
else
    for i=1:Segmentation_split_x
        lower_x=round(n*(i-1)*1/Segmentation_split_x)+1;
        upper_x=round(n*i*1/Segmentation_split_x);
        for j=1:Segmentation_split_y
        lower_y=round(m*(j-1)*1/Segmentation_split_y)+1;
        upper_y=round(m*j*1/Segmentation_split_y);
        Thresh = multithresh(I(lower_y:upper_y,lower_x:upper_x),2);
        Quant(lower_y:upper_y,lower_x:upper_x) = imquantize(I(lower_y:upper_y,lower_x:upper_x),Thresh);
        end
    end    
end    

PixSeparated = zeros(m,n,3);

PixSeparated(:,:,1) = (Quant==1);
PixSeparated(:,:,2) = (Quant==2);
PixSeparated(:,:,3) = (Quant==3);
