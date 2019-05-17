function Graph(CombinedMicrostructure,PixSeparated,MaxNumNeighbors,FolderPath,File)

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


Image_8bit = imread(char(strcat(FolderPath,'\',File(1),'.',File(2))));
Image_rgb=uint8(zeros(m,n,3));
for i=1:3
    Image_rgb(:,:,i)=Image_8bit(:,:);
end    

barycenters=zeros(NumCells,3,3);
for i=1:m
    for j=1:n
        barycenters(PixSeparatedLab(i,j,CombinedMicrostructure(i,j)),CombinedMicrostructure(i,j),1)=barycenters(PixSeparatedLab(i,j,CombinedMicrostructure(i,j)),CombinedMicrostructure(i,j),1)+i;
        barycenters(PixSeparatedLab(i,j,CombinedMicrostructure(i,j)),CombinedMicrostructure(i,j),2)=barycenters(PixSeparatedLab(i,j,CombinedMicrostructure(i,j)),CombinedMicrostructure(i,j),2)+j;    
        barycenters(PixSeparatedLab(i,j,CombinedMicrostructure(i,j)),CombinedMicrostructure(i,j),3)=barycenters(PixSeparatedLab(i,j,CombinedMicrostructure(i,j)),CombinedMicrostructure(i,j),3)+1;    
    end
end 

for i=1:NumCells
    for j=1:3
        if barycenters(i,j,3)>0
            barycenters(i,j,1)=barycenters(i,j,1)/barycenters(i,j,3);
            barycenters(i,j,2)=barycenters(i,j,2)/barycenters(i,j,3);
            Image_rgb(round(barycenters(i,j,1)),round(barycenters(i,j,2)),1)=255;
            Image_rgb(round(barycenters(i,j,1)),round(barycenters(i,j,2)),2)=0;
            Image_rgb(round(barycenters(i,j,1)),round(barycenters(i,j,2)),3)=0;
        end
    end
end    

plot(barycenters(:,2,2), m-barycenters(:,2,1),'ks','MarkerSize',7);
hold on;
plot(barycenters(:,3,2), m-barycenters(:,3,1),'ko','MarkerSize',6);
hold on;
% axis([0 -n 0 -m]);
axis([0 n 0 m]);
pbaspect([n m 1])
for i=1:NumCells
    for j=1:NumCells
        if NeighbourArray(i,j,3)>0
           plot([barycenters(i,2,2) barycenters(j,3,2)],[m-barycenters(i,2,1) m-barycenters(j,3,1)],'k');
           hold on;
        end   
    end
end   

S1=sum(NeighbourArray(:,:,3));
for i=1:NumCells
    if S1(i)>2
        plot(barycenters(i,3,2), m-barycenters(i,3,1),'ro','MarkerSize',6,'LineWidth',2);
        hold on;
    end    
    if S1(i)<2 && NonAttachedToBoundary(i,3)==1
        plot(barycenters(i,3,2), m-barycenters(i,3,1),'bo','MarkerSize',6,'LineWidth',2);
        hold on;
    end  
end    

S1=sum(NeighbourArray(:,:,3),2);
for i=1:NumCells
    if S1(i)>2
        plot(barycenters(i,2,2), m-barycenters(i,2,1),'rs','MarkerSize',6,'LineWidth',2);
        hold on;
    end    
    if S1(i)<2 && NonAttachedToBoundary(i,2)==1
        plot(barycenters(i,2,2), m-barycenters(i,2,1),'bs','MarkerSize',6,'LineWidth',2);
        hold on;
    end  
end  

fig = gcf;
fig.PaperUnits = 'points';
fig.PaperPosition = [0 0 round(n/4) round(m/4)];
print(char(strcat(FolderPath,'\',File(1),'_graph.png')),'-dpng')


a=1;

