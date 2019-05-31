function [PixSeparated] = Gray_border_reduction_Elizabeth_adjusted(PixSeparated,m,n)

cross3 = [0 1 0; 1 1 1; 0 1 0];
se = strel(cross3);

GryPix = imerode(PixSeparated(:,:,2),se);
WtDilate = imdilate(PixSeparated(:,:,3),se);
BlkDilate = imdilate(PixSeparated(:,:,1),se);

BlkPix=PixSeparated(:,:,1);
WtPix=PixSeparated(:,:,3);


for i = 1:m
    for j = 1:n
        if WtDilate(i,j) && ~BlkDilate(i,j)
            WtPix(i,j) = 1;
        end
        if BlkDilate(i,j) && ~WtDilate(i,j)
            BlkPix(i,j) = 1;
        end
     end
end

PixSeparated(:,:,3)=WtPix;
PixSeparated(:,:,2)=GryPix;
PixSeparated(:,:,1)=BlkPix;

for i = 1:m
    for j = 1:n
        if PixSeparated(i,j,1)==0 && PixSeparated(i,j,2)==0 && PixSeparated(i,j,3)==0
            PixSeparated(i,j,2)=1;
        end    
    end
end        