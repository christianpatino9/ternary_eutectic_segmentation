function [PixSeparated] = Gray_border_reduction_Elizabeth(PixSeparated,m,n)

cross3 = [0 1 0; 1 1 1; 0 1 0];
se = strel(cross3);
GryPix = imerode(PixSeparated(:,:,2),se);
WtDilate = imdilate(PixSeparated(:,:,3),se);

BlkPix=PixSeparated(:,:,1);
WtPix=PixSeparated(:,:,3);


for i = 1:m
    for j = 1:n
        if WtDilate(i,j) && ~BlkPix(i,j)
            WtPix(i,j) = 1;
        end
     end
end
GryDilate = imdilate(GryPix,se);
for i = 1:m
	for j = 1:n
        if GryDilate(i,j) && ~WtPix(i,j) && ~BlkPix(i,j)
            GryPix(i,j) = 1;
        end
	end
end


for i = 1:m
	for j = 1:n
        if ~BlkPix(i,j) && ~GryPix(i,j) && ~WtPix(i,j)
            BlkPix(i,j) = 1;
        end
	end
end

PixSeparated(:,:,3)=WtPix;
PixSeparated(:,:,2)=GryPix;
PixSeparated(:,:,1)=BlkPix;