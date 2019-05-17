function [av_shape_factor] = Shape_factor(PixSeparated,m,n)


av_shape_factor=zeros(3,1);
for p=1:3
PixSeparated_clear(:,:)=imclearborder(PixSeparated(:,:,p),8);
PixSeparated_Lab(:,:)=bwlabel(PixSeparated_clear(:,:));
maxnumfib=max(max(PixSeparated_Lab));
Border=zeros(m,n);
Border_fib=zeros(m,n);
Fiber_with_Interface=zeros(maxnumfib,1);

for i=1:m-1
    for j=1:n
        if PixSeparated_Lab(i,j) ~= PixSeparated_Lab(i+1,j)
            Border(i,j)=1;
            if PixSeparated_Lab(i,j)>0
                Border_fib(i,j)=PixSeparated_Lab(i,j);
            elseif PixSeparated_Lab(i+1,j)>0     
                Border_fib(i,j)=PixSeparated_Lab(i+1,j);
            else
                warning('Unexpected behavior')
            end    
        end 
    end
end

for i=1:m
    for j=1:n-1
        if PixSeparated_Lab(i,j) ~= PixSeparated_Lab(i,j+1)
            Border(i,j)=1;
            if PixSeparated_Lab(i,j)>0
                Border_fib(i,j)=PixSeparated_Lab(i,j);
            elseif PixSeparated_Lab(i,j+1)>0     
                Border_fib(i,j)=PixSeparated_Lab(i,j+1);
            else
                warning('Unexpected behavior')
            end   
        end 
    end
end

boundaries = bwboundaries(Border(:,:),8);
numberOfBoundaries = size(boundaries, 1);
Length=zeros(numberOfBoundaries,3);

for k = 1 : numberOfBoundaries
    dist=0;
    thisBoundary = boundaries{k};
    Length(k,1)=thisBoundary(1,2);
    Length(k,2)=thisBoundary(1,1);
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
    	dist=dist+sqrt((px(i)-px(i+1))^2+(py(i)-py(i+1))^2); 
    end    
%     Attention: here the perimeter is measured two times, added and halfed
%     later. 
%     Adding: line 87
%     Halving: line 110
    Length(k,3)=dist;
%     plot(px, py, 'red', 'LineWidth', 3);     
end
    
for k = 1:numberOfBoundaries  
        x=Length(k,1);
        y=Length(k,2);
        if x>0 && y>0 && Length(k,3)>0
            if Border_fib(y,x) >0
            Fiber_with_Interface(Border_fib(y,x),1)=Length(k,3)+Fiber_with_Interface(Border_fib(y,x),1);
            elseif x>1 && x<n-1 && y>1 && y<m-1 
                fib=max([Border_fib(y-1,x-1),Border_fib(y,x-1),Border_fib(y+1,x-1),Border_fib(y-1,x+1),Border_fib(y,x+1),Border_fib(y+1,x+1),Border_fib(y-1,x),Border_fib(y+1,x)]);
                Fiber_with_Interface(fib,1)=Length(k,3)+Fiber_with_Interface(fib,1);
            else 
                warning('Bad point')
            end    
        end
end   

% Particle size
Particle_size=zeros(maxnumfib,1);
for i=1:m
    for j=1:n
        if PixSeparated_Lab(i,j)>0
            Particle_size(PixSeparated_Lab(i,j),1)=Particle_size(PixSeparated_Lab(i,j),1)+1;
        end
    end
end    

Shape_factor=zeros(maxnumfib,1);
for i=1:maxnumfib
    Shape_factor(i,1)=4*pi*Particle_size(i,1)/(Fiber_with_Interface(i,1)^2/4);
    if Shape_factor(i,1)>1
        Shape_factor(i,1)=0;
    end    
end    

num_fib=0;
for i=1:maxnumfib
    if Shape_factor(i,1)>0
        av_shape_factor(p,1)=av_shape_factor(p,1)+Shape_factor(i,1);
        num_fib=num_fib+1;
    end    
end    

av_shape_factor(p,1)=av_shape_factor(p,1)/num_fib;
end