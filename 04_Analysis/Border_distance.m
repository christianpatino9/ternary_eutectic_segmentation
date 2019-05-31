function [Distance_map] = Border_distance(PixSeparated,m,n,FolderPath,File)

Distance_map=10000*ones(m,n,4);
for i=1:m
    for j=1:n
        for r=20:20:1000
            for k=i-r:i+r
                for q=j-r:j+r
                    if all([k>0,q>0,k<m+1,q<n+1])
                       if all([k==i,q==j])
                           
                       else    
                        if PixSeparated(i,j,1)==1
                            if PixSeparated(k,q,2)==1
                                dist=sqrt((i-k)^2+(j-q)^2);
                                if dist<Distance_map(i,j,1)
                                   Distance_map(i,j,1)=dist;
                                end
                            elseif PixSeparated(k,q,3)==1   
                                dist=sqrt((i-k)^2+(j-q)^2);
                                if dist<Distance_map(i,j,2)
                                   Distance_map(i,j,2)=dist;
                                end
                            else
                            end
                       elseif PixSeparated(i,j,2)==1
                            if PixSeparated(k,q,1)==1
                                dist=sqrt((i-k)^2+(j-q)^2);
                                if dist<Distance_map(i,j,1)
                                   Distance_map(i,j,1)=dist;
                                end
                            elseif PixSeparated(k,q,3)==1   
                                dist=sqrt((i-k)^2+(j-q)^2);
                                if dist<Distance_map(i,j,3)
                                   Distance_map(i,j,3)=dist;
                                end
                            else
                            end
                       else
                            if PixSeparated(k,q,1)==1
                                dist=sqrt((i-k)^2+(j-q)^2);
                                if dist<Distance_map(i,j,2)
                                   Distance_map(i,j,2)=dist;
                                end
                            elseif PixSeparated(k,q,2)==1   
                                dist=sqrt((i-k)^2+(j-q)^2);
                                if dist<Distance_map(i,j,3)
                                   Distance_map(i,j,3)=dist;
                                end
                            else
                            end    
                        end
                       end 
                    end         
                end % INNER MOST LOOP
            end
        if sum(Distance_map(i,j,:) == 10000) ==2
            break
        end     
        end
    end
end    
                            
for i=1:m
    for j=1:n
        for k=1:3   
            if Distance_map(i,j,k)==10000
              Distance_map(i,j,k)=0;  
            end    
        end    
    end
end    

for i=1:m
    for j=1:n
        Distance_map(i,j,4)=max(Distance_map(i,j,1:3));
    end
end 

max_Val=max(max(Distance_map(:,:,1)))
min_Val=min(min(Distance_map(:,:,1)))
slope=(0-0.75)/(max_Val-min_Val);
y_value=0.75-slope*min_Val;

Image_rgb=zeros(m,n,3);

for i=1:m
    for j=1:n
            Val=Distance_map(i,j,1);
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
imwrite(uint8(Image_rgb),char(strcat(FolderPath,'\',File(1),'_max_dist_12.tif')))

max_Val=max(max(Distance_map(:,:,2)))
min_Val=min(min(Distance_map(:,:,2)))
slope=(0-0.75)/(max_Val-min_Val);
y_value=0.75-slope*min_Val;

Image_rgb=zeros(m,n,3);

for i=1:m
    for j=1:n
            Val=Distance_map(i,j,2);
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
imwrite(uint8(Image_rgb),char(strcat(FolderPath,'\',File(1),'_max_dist_13.tif')))

max_Val=max(max(Distance_map(:,:,3)))
min_Val=min(min(Distance_map(:,:,3)))
slope=(0-0.75)/(max_Val-min_Val);
y_value=0.75-slope*min_Val;

Image_rgb=zeros(m,n,3);

for i=1:m
    for j=1:n
            Val=Distance_map(i,j,3);
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
imwrite(uint8(Image_rgb),char(strcat(FolderPath,'\',File(1),'_max_dist_23.tif')))

max_Val=max(max(Distance_map(:,:,4)))
min_Val=min(min(Distance_map(:,:,4)))
slope=(0-0.75)/(max_Val-min_Val);
y_value=0.75-slope*min_Val;

Image_rgb=zeros(m,n,3);

for i=1:m
    for j=1:n
            Val=Distance_map(i,j,4);
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
imwrite(uint8(Image_rgb),char(strcat(FolderPath,'\',File(1),'_max_dist.tif')))

