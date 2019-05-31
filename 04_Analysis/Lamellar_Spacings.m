function [dist_average,spacing_dist]= Lamellar_Spacings(CombinedMicrostructure,PhasesToAnalyze,PixSeparated)
%technically centroid spacings

%dist_average(i,j) lists average closest-distance to same-phase i centroid
% for which the midpoint between centroids is phase j

%spacing_dist{i}(j) lists full distribution of closest-distance to
% same-phase i centroid for which midpoint between centroids is phase j;
% spacing_dist{i}(4) lists distribution of closest same-phase centroid
% distance overall.

%[m,n] = size(CombinedMicrostructure);
dist_average=zeros(3,4);
spacing_dist=cell(3,1);
for k=1:3
    if ~PhasesToAnalyze(k)
        continue
    else
       PixSeparated_clear(:,:,k)=imclearborder(PixSeparated(:,:,k));
       Stats = regionprops('table',bwlabel(PixSeparated_clear(:,:,k),4),'Area', 'Centroid', 'MajorAxisLength','MinorAxisLength');
       numFibers=size(Stats,1);
       dist_matrix=ones(numFibers,11)*10000;
       spacing_dist{k}=zeros(numFibers,4);

       counter=zeros(4,1);
       for i=1:numFibers
           cent1x = Stats.Centroid(i,2);
           cent1y = Stats.Centroid(i,1);
           dist_matrix(i,1)=cent1x;
           dist_matrix(i,2)=cent1y;
           for j=1:numFibers
                cent2x = Stats.Centroid(j,2);
                cent2y = Stats.Centroid(j,1);
                dist = sqrt((cent1x-cent2x)^2 + (cent1y-cent2y)^2);
                midx = round((cent1x+cent2x)/2);
                midy = round((cent1y+cent2y)/2);
                
                if dist<dist_matrix(i,CombinedMicrostructure(midx,midy)*3+2) && dist>0.0001
                    dist_matrix(i,CombinedMicrostructure(midx,midy)*3+2)=dist;
                    dist_matrix(i,CombinedMicrostructure(midx,midy)*3)=cent2x;
                    dist_matrix(i,CombinedMicrostructure(midx,midy)*3+1)=cent2y;
                end
           end
           for a = 1:3
               if ~(dist_matrix(i,a*3) == 10000 && dist_matrix(i,a*3+1) == 10000 && dist_matrix(i,a*3+2)==10000)
                   spacing_dist{k}(i,a) = dist_matrix(i,a*3+2);
               end
           end
           spacing_dist{k}(i,4) = min(min(dist_matrix(i,5),dist_matrix(i,8)),dist_matrix(i,11));
       end
       
       for i=1:numFibers
          for j=1:11
            if dist_matrix(i,j)==10000
                dist_matrix(i,j)=0;
            end 
          end
          
          if dist_matrix(i,5)>0
            dist_average(k,1)=dist_average(k,1)+dist_matrix(i,5);
            counter(1,1)=counter(1,1)+1;
          end
          if dist_matrix(i,8)>0
            dist_average(k,2)=dist_average(k,2)+dist_matrix(i,8);
            counter(2,1)=counter(2,1)+1;
          end
          if dist_matrix(i,11)>0
            dist_average(k,3)=dist_average(k,3)+dist_matrix(i,11);
            counter(3,1)=counter(3,1)+1;
          end
          dist_average(k,4)=dist_average(k,4)+spacing_dist{k}(i,4);
          counter(4,1)=counter(4,1)+1;
          
       end
       for l=1:4
            dist_average(k,l)=dist_average(k,l)/counter(l,1);
       end

       
    end
end 
