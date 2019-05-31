function [PixSeparated,changed_pixels] = Small_region_correction(PixSeparated, minimumsize)

[m,n] = size(PixSeparated(:,:,1));
PixSeparatedLab=zeros(m,n,3);


for i = 1:3
  PixSeparatedLab(:,:,i)=bwlabel(PixSeparated(:,:,i),4);  
end 

NumCells=zeros(max(max(max(PixSeparatedLab))),3);
CombinedMicrostructure=PixSeparated(:,:,1)+2*PixSeparated(:,:,2)+3*PixSeparated(:,:,3);
PixSeparated_after=PixSeparated;

for i = 1:m
    for j = 1:n
        NumCells(PixSeparatedLab(i,j,CombinedMicrostructure(i,j)),CombinedMicrostructure(i,j))=NumCells(PixSeparatedLab(i,j,CombinedMicrostructure(i,j)),CombinedMicrostructure(i,j))+1;
    end
end
changed_pixels=0;
Direct_Neighbors=zeros(3,1);
for i = 2:m-1
    for j = 2:n-1
        if NumCells(PixSeparatedLab(i,j,CombinedMicrostructure(i,j)),CombinedMicrostructure(i,j)) > minimumsize 
            continue
        else        
            Direct_Neighbors(:,1)=PixSeparated(i-1,j,:)+PixSeparated(i+1,j,:)+PixSeparated(i-1,j-1,:)+PixSeparated(i+1,j-1,:)+PixSeparated(i,j-1,:)+PixSeparated(i-1,j+1,:)+PixSeparated(i+1,j+1,:)+PixSeparated(i,j+1,:);
            [val, idx] = max(Direct_Neighbors);
            number_maximum_values=sum(Direct_Neighbors(:,1) == val);

            
            if number_maximum_values==1 && CombinedMicrostructure(i,j)== idx
                continue
            elseif number_maximum_values==1 && CombinedMicrostructure(i,j) ~= idx
                PixSeparated_after(i,j,CombinedMicrostructure(i,j))=0;
                PixSeparated_after(i,j,idx)=1;
                changed_pixels=changed_pixels+1;
            else  
                num=randi([1 2],1,1);
                if num==1 && CombinedMicrostructure(i,j) ~= idx
                    PixSeparated_after(i,j,idx)=1;
                    PixSeparated_after(i,j,CombinedMicrostructure(i,j))=0;
                    changed_pixels=changed_pixels+1;
                elseif num==2 && CombinedMicrostructure(i,j) ~= find(Direct_Neighbors==val,1,'last')       
                    PixSeparated_after(i,j,find(Direct_Neighbors==val,1,'last'))=1;
                    PixSeparated_after(i,j,CombinedMicrostructure(i,j))=0;
                    changed_pixels=changed_pixels+1;
                else
                end    
            end         
        end    
    end
end    

PixSeparated=PixSeparated_after;
