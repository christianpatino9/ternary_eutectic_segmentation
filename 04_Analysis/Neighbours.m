function [Nearest_Neighbours]= Neighbours(CombinedMicrostructure,PixSeparated,MaxNumNeighbors)

[m,n] = size(CombinedMicrostructure);

PixSeparatedLab=zeros(m,n,3);
for i = 1:3
  PixSeparatedLab(:,:,i)=bwlabel(PixSeparated(:,:,i),4);  
  PixSeparated_clear(:,:,i)=imclearborder(PixSeparated(:,:,i));
end

NumCells=max(max(max(PixSeparatedLab)));
NeighbourArray=zeros(NumCells,NumCells,3);
Nearest_Neighbours=zeros(MaxNumNeighbors+1,4,3);
NonAttachedToBoundary=zeros(NumCells,3);

for i=1:m-1
    for j=1:n
        if CombinedMicrostructure(i,j) ~= CombinedMicrostructure(i+1,j)            
            if CombinedMicrostructure(i,j)==1 && CombinedMicrostructure(i+1,j)==2
               NeighbourArray(PixSeparatedLab(i,j,1),PixSeparatedLab(i+1,j,2),1)=1; 
            elseif CombinedMicrostructure(i,j)==2 && CombinedMicrostructure(i+1,j)==1
               NeighbourArray(PixSeparatedLab(i+1,j,1),PixSeparatedLab(i,j,2),1)=1; 

            elseif CombinedMicrostructure(i,j)==1 && CombinedMicrostructure(i+1,j)==3
               NeighbourArray(PixSeparatedLab(i,j,1),PixSeparatedLab(i+1,j,3),2)=1; 
            elseif CombinedMicrostructure(i,j)==3 && CombinedMicrostructure(i+1,j)==1
               NeighbourArray(PixSeparatedLab(i+1,j,1),PixSeparatedLab(i,j,3),2)=1; 

            elseif CombinedMicrostructure(i,j)==2 && CombinedMicrostructure(i+1,j)==3
               NeighbourArray(PixSeparatedLab(i,j,2),PixSeparatedLab(i+1,j,3),3)=1; 
            elseif CombinedMicrostructure(i,j)==3 && CombinedMicrostructure(i+1,j)==2
               NeighbourArray(PixSeparatedLab(i+1,j,2),PixSeparatedLab(i,j,3),3)=1; 
            else
               disp('Error')
            end    
        end   
    end
end 

for i=1:m
    for j=1:n-1
        if CombinedMicrostructure(i,j) ~= CombinedMicrostructure(i,j+1)            
            if CombinedMicrostructure(i,j)==1 && CombinedMicrostructure(i,j+1)==2
               NeighbourArray(PixSeparatedLab(i,j,1),PixSeparatedLab(i,j+1,2),1)=1; 
            elseif CombinedMicrostructure(i,j)==2 && CombinedMicrostructure(i,j+1)==1
               NeighbourArray(PixSeparatedLab(i,j+1,1),PixSeparatedLab(i,j,2),1)=1; 

            elseif CombinedMicrostructure(i,j)==1 && CombinedMicrostructure(i,j+1)==3
               NeighbourArray(PixSeparatedLab(i,j,1),PixSeparatedLab(i,j+1,3),2)=1; 
            elseif CombinedMicrostructure(i,j)==3 && CombinedMicrostructure(i,j+1)==1
               NeighbourArray(PixSeparatedLab(i,j+1,1),PixSeparatedLab(i,j,3),2)=1; 

            elseif CombinedMicrostructure(i,j)==2 && CombinedMicrostructure(i,j+1)==3
               NeighbourArray(PixSeparatedLab(i,j,2),PixSeparatedLab(i,j+1,3),3)=1; 
            elseif CombinedMicrostructure(i,j)==3 && CombinedMicrostructure(i,j+1)==2
               NeighbourArray(PixSeparatedLab(i,j+1,2),PixSeparatedLab(i,j,3),3)=1; 
            else
               disp('Error')
            end    
        end   
    end
end 

for i=1:m
    for j=1:n
        for k=1:3
            if PixSeparated_clear(i,j,k)==1
               NonAttachedToBoundary(PixSeparatedLab(i,j,k),k)=1; 
            end    
        end    
    end
end    


S1=sum(NeighbourArray(:,:,1),2);
S2=sum(NeighbourArray(:,:,2),2);
for i=1:NumCells
    if NonAttachedToBoundary(i,1)==1
        N1=S1(i);
        N2=S2(i);
        if N1>MaxNumNeighbors
            N1=MaxNumNeighbors;
        end
        if N2>MaxNumNeighbors
            N2=MaxNumNeighbors;
        end
            
        Nearest_Neighbours(N1+1,3,1)=Nearest_Neighbours(N1+1,3,1)+1;
        Nearest_Neighbours(N2+1,4,1)=Nearest_Neighbours(N2+1,4,1)+1;
    end 
end

S1=sum(NeighbourArray(:,:,1));
S2=sum(NeighbourArray(:,:,3),2);
for i=1:NumCells
    if NonAttachedToBoundary(i,2)==1
        N1=S1(i);
        N2=S2(i);
        if N1>MaxNumNeighbors
            N1=MaxNumNeighbors;
        end
        if N2>MaxNumNeighbors
            N2=MaxNumNeighbors;
        end
        
        Nearest_Neighbours(N1+1,2,2)=Nearest_Neighbours(N1+1,2,2)+1;
        Nearest_Neighbours(N2+1,4,2)=Nearest_Neighbours(N2+1,4,2)+1;
    end 
end

S1=sum(NeighbourArray(:,:,2));
S2=sum(NeighbourArray(:,:,3));
for i=1:NumCells
    if NonAttachedToBoundary(i,3)==1
        N1=S1(i);
        N2=S2(i);
        if N1>MaxNumNeighbors
            N1=MaxNumNeighbors;
        end
        if N2>MaxNumNeighbors
            N2=MaxNumNeighbors;
        end
        
        Nearest_Neighbours(N1+1,2,3)=Nearest_Neighbours(N1+1,2,3)+1;
        Nearest_Neighbours(N2+1,3,3)=Nearest_Neighbours(N2+1,3,3)+1;
    end 
end

for i=1:MaxNumNeighbors+1
    Nearest_Neighbours(i,1,:)=i-1;
end


