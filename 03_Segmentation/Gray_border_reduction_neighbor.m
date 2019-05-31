function [PixSeparated,changed_pixels] = Gray_border_reduction_neighbor(PixSeparated,m,n)
cross3 = [0 1 0; 1 1 1; 0 1 0];
se = strel(cross3);

WtDilate = imdilate(PixSeparated(:,:,3),se);
BlkDilate = imdilate(PixSeparated(:,:,1),se);

PixSeparated_after=PixSeparated;
changed_pixels=0;

for i = 2:m-1
    for j = 2:n-1
        if PixSeparated(i,j,1) || PixSeparated(i,j,3)
            continue
        end
        Gryneighbor=PixSeparated(i+1,j,2)+PixSeparated(i-1,j,2)+PixSeparated(i+1,j+1,2)+PixSeparated(i,j+1,2)+PixSeparated(i-1,j+1,2)+PixSeparated(i+1,j-1,2)+PixSeparated(i,j-1,2)+PixSeparated(i-1,j-1,2);          
        if BlkDilate(i,j) && ~WtDilate(i,j)
            Wtneighbor=WtDilate(i+1,j)+WtDilate(i-1,j)+WtDilate(i+1,j+1)+WtDilate(i,j+1)+WtDilate(i-1,j+1)+WtDilate(i+1,j-1)+WtDilate(i,j-1)+WtDilate(i-1,j-1);
            Blkneighbor=PixSeparated(i+1,j,1)+PixSeparated(i-1,j,1)+PixSeparated(i+1,j+1,1)+PixSeparated(i,j+1,1)+PixSeparated(i-1,j+1,1)+PixSeparated(i+1,j-1,1)+PixSeparated(i,j-1,1)+PixSeparated(i-1,j-1,1);
            if Wtneighbor>0 && Blkneighbor>Gryneighbor 
                PixSeparated_after(i,j,1)=1;
                PixSeparated_after(i,j,2)=0;
                changed_pixels=changed_pixels+1;
            end
            continue
        end
        if ~BlkDilate(i,j) && WtDilate(i,j)
            Blkneighbor=BlkDilate(i+1,j)+BlkDilate(i-1,j)+BlkDilate(i+1,j+1)+BlkDilate(i,j+1)+BlkDilate(i-1,j+1)+BlkDilate(i+1,j-1)+BlkDilate(i,j-1)+BlkDilate(i-1,j-1);
            Wtneighbor=PixSeparated(i+1,j,3)+PixSeparated(i-1,j,3)+PixSeparated(i+1,j+1,3)+PixSeparated(i,j+1,3)+PixSeparated(i-1,j+1,3)+PixSeparated(i+1,j-1,3)+PixSeparated(i,j-1,3)+PixSeparated(i-1,j-1,3);
            if Blkneighbor>0 && Wtneighbor>Gryneighbor 
                PixSeparated_after(i,j,3)=1;
                PixSeparated_after(i,j,2)=0;
                changed_pixels=changed_pixels+1;
            end
            continue
        end
        if BlkDilate(i,j) && WtDilate(i,j)
            Blkneighbor=PixSeparated(i+1,j,1)+PixSeparated(i-1,j,1)+PixSeparated(i+1,j+1,1)+PixSeparated(i,j+1,1)+PixSeparated(i-1,j+1,1)+PixSeparated(i+1,j-1,1)+PixSeparated(i,j-1,1)+PixSeparated(i-1,j-1,1);
            Wtneighbor=PixSeparated(i+1,j,3)+PixSeparated(i-1,j,3)+PixSeparated(i+1,j+1,3)+PixSeparated(i,j+1,3)+PixSeparated(i-1,j+1,3)+PixSeparated(i+1,j-1,3)+PixSeparated(i,j-1,3)+PixSeparated(i-1,j-1,3);
            if Blkneighbor>Wtneighbor && Blkneighbor>Gryneighbor
                PixSeparated_after(i,j,1)=1;
                PixSeparated_after(i,j,2)=0;
                changed_pixels=changed_pixels+1;
            elseif Blkneighbor<Wtneighbor && Wtneighbor>Gryneighbor
                PixSeparated_after(i,j,3)=1;
                PixSeparated_after(i,j,2)=0;
                changed_pixels=changed_pixels+1;
            elseif Blkneighbor==Wtneighbor && Blkneighbor>Gryneighbor
                num=randi([1 2],1,1);
                if num==1
                    PixSeparated_after(i,j,1)=1;
                    PixSeparated_after(i,j,2)=0;
                    changed_pixels=changed_pixels+1;
                else
                    PixSeparated_after(i,j,3)=1;
                    PixSeparated_after(i,j,2)=0;
                    changed_pixels=changed_pixels+1;
                end    
            else  
            end  
            continue
        end    
    end
end
PixSeparated=PixSeparated_after;