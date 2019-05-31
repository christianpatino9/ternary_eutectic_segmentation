function [av_if_length,av_if_length_relative,angles_rel_hist] = Interface_Lenght(PixSeparated,CombinedMicrostructure,m,n)

PixSeparated_Lab(:,:,1)=bwlabel(PixSeparated(:,:,1));
PixSeparated_Lab(:,:,2)=bwlabel(PixSeparated(:,:,2));
PixSeparated_Lab(:,:,3)=bwlabel(PixSeparated(:,:,3));
PixSeparated_clear(:,:,1)=imclearborder(PixSeparated(:,:,1),8);
PixSeparated_clear(:,:,2)=imclearborder(PixSeparated(:,:,2),8);
PixSeparated_clear(:,:,3)=imclearborder(PixSeparated(:,:,3),8);
maxnumfib=max(max(max(PixSeparated_Lab)));
Fiber_with_Interface=zeros(3,maxnumfib,3);
Border=zeros(m,n,3);
Border_fib=zeros(m,n,3,2);
av_if_length=zeros(9,2);
av_if_length_relative=zeros(12,2);
angles=zeros(181,3);

for i=1:m-1
    for j=1:n
        if CombinedMicrostructure(i,j) ~= CombinedMicrostructure(i+1,j)
            if CombinedMicrostructure(i,j)==1 && CombinedMicrostructure(i+1,j)==2
                Border(i,j,1)=1;
                Border_fib(i,j,1,1)=PixSeparated_Lab(i,j,1);
                Border_fib(i,j,1,2)=PixSeparated_Lab(i+1,j,2);
            elseif CombinedMicrostructure(i,j)==2 && CombinedMicrostructure(i+1,j)==1   
                Border(i,j,1)=1;
                Border_fib(i,j,1,1)=PixSeparated_Lab(i+1,j,1);
                Border_fib(i,j,1,2)=PixSeparated_Lab(i,j,2);
            elseif CombinedMicrostructure(i,j)==1 && CombinedMicrostructure(i+1,j)==3 
                Border(i,j,2)=1;
                Border_fib(i,j,2,1)=PixSeparated_Lab(i,j,1);
                Border_fib(i,j,2,2)=PixSeparated_Lab(i+1,j,3);
            elseif CombinedMicrostructure(i,j)==3 && CombinedMicrostructure(i+1,j)==1
                Border(i,j,2)=1;
                Border_fib(i,j,2,1)=PixSeparated_Lab(i+1,j,1);
                Border_fib(i,j,2,2)=PixSeparated_Lab(i,j,3);
            elseif CombinedMicrostructure(i,j)==2 && CombinedMicrostructure(i+1,j)==3
                Border(i,j,3)=1;   
                Border_fib(i,j,3,1)=PixSeparated_Lab(i,j,2);
                Border_fib(i,j,3,2)=PixSeparated_Lab(i+1,j,3);
             elseif CombinedMicrostructure(i,j)==3 && CombinedMicrostructure(i+1,j)==2
                Border(i,j,3)=1;   
                Border_fib(i,j,3,1)=PixSeparated_Lab(i+1,j,2);
                Border_fib(i,j,3,2)=PixSeparated_Lab(i,j,3);    
            else 
                warning('Unexpected behavior')
            end
        end 
    end
end

for i=1:m
    for j=1:n-1
        if CombinedMicrostructure(i,j) ~= CombinedMicrostructure(i,j+1)
            if (CombinedMicrostructure(i,j)==1 && CombinedMicrostructure(i,j+1)==2) 
                Border(i,j,1)=1;
                Border_fib(i,j,1,1)=PixSeparated_Lab(i,j,1);
                Border_fib(i,j,1,2)=PixSeparated_Lab(i,j+1,2);
            elseif (CombinedMicrostructure(i,j)==2 && CombinedMicrostructure(i,j+1)==1)
                Border(i,j,1)=1;
                Border_fib(i,j,1,1)=PixSeparated_Lab(i,j+1,1);
                Border_fib(i,j,1,2)=PixSeparated_Lab(i,j,2);    
            elseif (CombinedMicrostructure(i,j)==1 && CombinedMicrostructure(i,j+1)==3) 
                Border(i,j,2)=1;
                Border_fib(i,j,2,1)=PixSeparated_Lab(i,j,1);
                Border_fib(i,j,2,2)=PixSeparated_Lab(i,j+1,3);
            elseif (CombinedMicrostructure(i,j)==3 && CombinedMicrostructure(i,j+1)==1)
                Border(i,j,2)=1;
                Border_fib(i,j,2,1)=PixSeparated_Lab(i,j+1,1);
                Border_fib(i,j,2,2)=PixSeparated_Lab(i,j,3);    
            elseif (CombinedMicrostructure(i,j)==2 && CombinedMicrostructure(i,j+1)==3)
                Border(i,j,3)=1;   
                Border_fib(i,j,3,1)=PixSeparated_Lab(i,j,2);
                Border_fib(i,j,3,2)=PixSeparated_Lab(i,j+1,3);
            elseif (CombinedMicrostructure(i,j)==3 && CombinedMicrostructure(i,j+1)==2)
                Border(i,j,3)=1;   
                Border_fib(i,j,3,1)=PixSeparated_Lab(i,j+1,2);
                Border_fib(i,j,3,2)=PixSeparated_Lab(i,j,3);    
            else 
                warning('Unexpected behavior')
            end
        end 
        
    end
end

% k=1 1-2 boundary
% k=2 1-3 boundary
% k=3 2-3 boundary
numberOfBoundaries_old=1;
Length=zeros(numberOfBoundaries_old,3,3);
for p=1:3
    boundaries = bwboundaries(Border(:,:,p),8);
    numberOfBoundaries = size(boundaries, 1);
    [q,~,~]=size(Length);
    if q<numberOfBoundaries
        Length= [Length; zeros(numberOfBoundaries-q,3,3)];
    end
    for k = 1 : numberOfBoundaries
        dist=0;
        thisBoundary = boundaries{k};
        Length(k,1,p)=thisBoundary(1,2);
        Length(k,2,p)=thisBoundary(1,1);
        x = thisBoundary(:, 2);
        y = thisBoundary(:, 1);

        boundaryLength = length(x);
        % Smooth the boundary.  First subsample it.
        subSamplingFactor = 3;
        xSubsampled = x(1 : subSamplingFactor : end);
        ySubsampled = y(1 : subSamplingFactor : end);
        numInterpolatingPoints = length(xSubsampled);
        if numInterpolatingPoints <= 2
            continue;
        end
        % Smooth x coordinates.
        t = 1 : boundaryLength;
        tx = linspace(1, boundaryLength, numInterpolatingPoints);
        px = pchip(tx, xSubsampled, t);
        % Smooth y coordinates.
        py = pchip(tx, ySubsampled, t);
        px(end+1)=px(1);
        py(end+1)=py(1);
        for i=1 : length(px)-1
        	if py(i+1)==py(i)
                angles(181,p)=angles(181,p)+1;
            else    
                angle=round(atan((px(i+1)-px(i))/(py(i+1)-py(i)))*180/pi+90);
                angles(angle+1,p)=angles(angle+1,p)+1;
            end
            dist=dist+sqrt((px(i)-px(i+1))^2+(py(i)-py(i+1))^2); 
        end    
        Length(k,3,p)=dist;
%         plot(px, py, 'red', 'LineWidth', 3);     
    end 
    [q,~,~]=size(Length);
    for i=1:q-1
        for j=i+1:q
            if Length(i,3,p)>0
                dist_x=abs(Length(i,1,p)-Length(j,1,p));
                dist_y=abs(Length(i,2,p)-Length(j,2,p));
                if dist_x<3 && dist_y<3
                    Length(i,3,p)=Length(i,3,p)+Length(j,3,p);
                    Length(j,3,p)=0;
                end
            end
        end
    end
    for i=1:q
        Length(i,3,p)=Length(i,3,p)/2;
    end  
%     Linking the fiber number with the interface length
    for k = 1:q  
        x=Length(k,1,p);
        y=Length(k,2,p);
        if x>0 && y>0 && Length(k,3,p)>0
            if Border_fib(y,x,p,2) ==0 || Border_fib(y,x,p,1) ==0
            elseif p==1 
                Fiber_with_Interface(1,Border_fib(y,x,p,1),p)=Length(k,3,p)+Fiber_with_Interface(1,Border_fib(y,x,p,1),p);
                Fiber_with_Interface(2,Border_fib(y,x,p,2),p)=Length(k,3,p)+Fiber_with_Interface(2,Border_fib(y,x,p,2),p);
            elseif p==2
                Fiber_with_Interface(1,Border_fib(y,x,p,1),p)=Length(k,3,p)+Fiber_with_Interface(1,Border_fib(y,x,p,1),p);
                Fiber_with_Interface(3,Border_fib(y,x,p,2),p)=Length(k,3,p)+Fiber_with_Interface(3,Border_fib(y,x,p,2),p);
            elseif p==3
                Fiber_with_Interface(2,Border_fib(y,x,p,1),p)=Length(k,3,p)+Fiber_with_Interface(2,Border_fib(y,x,p,1),p);
                Fiber_with_Interface(3,Border_fib(y,x,p,2),p)=Length(k,3,p)+Fiber_with_Interface(3,Border_fib(y,x,p,2),p);
            else 
                warning('Unexpected behavior')
            end
        end    
    end    
end

% Remove the rods touching the boundary
for i=1:m
    for j=1:n
        if (PixSeparated(i,j,1)==1) && (PixSeparated_clear(i,j,1)==0)
            Fiber_with_Interface(1,PixSeparated_Lab(i,j,1),:)=0;
        elseif PixSeparated(i,j,2)==1 && PixSeparated_clear(i,j,2)==0
            Fiber_with_Interface(2,PixSeparated_Lab(i,j,2),:)=0;
         elseif PixSeparated(i,j,3)==1 && PixSeparated_clear(i,j,3)==0
            Fiber_with_Interface(3,PixSeparated_Lab(i,j,3),:)=0; 
        else   
        end    
    end
end    

Particle_size=zeros(maxnumfib,3);
% 4: 1=1-2; 2=1-3; 3=2-3; 4=all
Fiber_length_per_size=zeros(3,maxnumfib,4);

for i=1:m
    for j=1:n
        if PixSeparated_Lab(i,j,1) > 0
            Particle_size(PixSeparated_Lab(i,j,1),1)=Particle_size(PixSeparated_Lab(i,j,1),1)+1;
        end
        
        if PixSeparated_Lab(i,j,2) > 0 
            Particle_size(PixSeparated_Lab(i,j,2),2)=Particle_size(PixSeparated_Lab(i,j,2),2)+1;
        end
        
        if PixSeparated_Lab(i,j,3) > 0
            Particle_size(PixSeparated_Lab(i,j,3),3)=Particle_size(PixSeparated_Lab(i,j,3),3)+1;
        end    
    end
end    

for i=1:3 % Phases
    for j=1:maxnumfib
        sum1=0;
        for k= 1:3 % Interfaces
            Fiber_length_per_size(i,j,k)=Fiber_with_Interface(i,j,k)/Particle_size(j,i);
            sum1=sum1+Fiber_with_Interface(i,j,k);
        end
        Fiber_length_per_size(i,j,4)=sum1/Particle_size(j,i);
    end
end    

for i=1:3
	for k=1:4
        for j=1:maxnumfib
           if Fiber_length_per_size(i,j,k)>0
               av_if_length_relative((i-1)*4+k,1)=av_if_length_relative((i-1)*4+k,1)+Fiber_length_per_size(i,j,k);
               av_if_length_relative((i-1)*4+k,2)=av_if_length_relative((i-1)*4+k,2)+1; 
           end
        end
    end
end   

for i=1:12
    if av_if_length_relative(i,2)>0
    av_if_length_relative(i,1)=av_if_length_relative(i,1)/av_if_length_relative(i,2);
    end
end

for i=1:3
	for k=1:3
        for j=1:maxnumfib
           if Fiber_with_Interface(i,j,k)>0
               av_if_length((i-1)*3+k,1)=av_if_length((i-1)*3+k,1)+Fiber_with_Interface(i,j,k);
               av_if_length((i-1)*3+k,2)=av_if_length((i-1)*3+k,2)+1; 
           end
        end
    end
end    


for i=1:9
    if av_if_length(i,2)>0
    av_if_length(i,1)=av_if_length(i,1)/av_if_length(i,2);
    end
end


angles_rel_hist = zeros(18,4);
j=1;
sum1=0;
k=1;
angles(1,:)=angles(1,:)+angles(181,:);

for p=1:3
    k=1;
    sum1=0;
    for i =1:180
        j=j+1;
        sum1=sum1+angles(i,p);
        if j==11
            j=1;
            angles_rel_hist(k,1)=k;
            angles_rel_hist(k,p+1)=sum1;
            k=k+1;
            sum1=0;
        end 
    end    
end

for i = 2:4
    angles_rel_hist(:,i)=angles_rel_hist(:,i)/sum(angles_rel_hist(:,i));
end    
%                            p          IF
% Fiber_with_Interface=zeros(3,maxnumfib,3);