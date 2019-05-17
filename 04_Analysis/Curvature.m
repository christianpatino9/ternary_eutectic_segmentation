function [av_curvature,max_curvature,min_curvature] = Curvature(PixSeparated,m,n,FolderPath,File)
% Attention: for this method the outer contour is used, which is half a
% pixel to wide. For the other methods using the surface both inner and
% outer contour is used averaged.

%     Just for plotting  
% Image_8bit = imread(char(strcat(FolderPath,'\',File(1),'.',File(2))));
% Image_rgb=uint8(zeros(m,n,3));
% for i=1:3
%     Image_rgb(:,:,i)=Image_8bit(:,:);
% end  
% imshow(Image_rgb);
% hold on;

for p=1:3
    PixSeparated_clear(:,:,p)=imclearborder(PixSeparated(:,:,p),8);
    PixSeparated_Lab(:,:,p)=bwlabel(PixSeparated_clear(:,:,p));
end


maxnumfib=max(max(max(PixSeparated_Lab)));
av_curvature=zeros(3,maxnumfib);
max_curvature=zeros(3,maxnumfib);
min_curvature=zeros(3,maxnumfib);

numberOfBoundaries_old=1;
Particle=zeros(numberOfBoundaries_old,3,3);
for p=1:3
    boundaries = bwboundaries(PixSeparated_Lab(:,:,p),8);
    numberOfBoundaries = size(boundaries, 1);
    [q,~,~]=size(Particle);
    if q<numberOfBoundaries
        Particle= [Particle; zeros(numberOfBoundaries-q,3,3)];
    end

    for k = 1 : numberOfBoundaries
        max_K=0;
        min_K=1000;
        av_K=0;
        num_K=0;
        thisBoundary = boundaries{k};
        [leng,~]=size(thisBoundary);
        curvatures=zeros(leng+2,2);
        Particle(k,p,1)=thisBoundary(1,2);
        Particle(k,p,2)=thisBoundary(1,1);
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
        px(end+1)=px(2);
        py(end+1)=py(2);
        for i=2 : length(px)-1
            x1=px(i-1);
            x2=px(i);
            x3=px(i+1);
            y1=py(i-1);
            y2=py(i);
            y3=py(i+1);
            K = 2*abs((x2-x1).*(y3-y1)-(x3-x1).*(y2-y1))/sqrt(((x2-x1).^2+(y2-y1).^2)*((x3-x1).^2+(y3-y1).^2)*((x3-x2).^2+(y3-y2).^2));

            if ~isnan(K)
                av_K=av_K+K;
                num_K=num_K+1;
                if K>max_K
                    max_K=K;
                end;
                if K<min_K
                    min_K=K;
                end;
            else    
                K=0;
            end  
            curvatures(i,1)=K;



                   
        end
%     Just for plotting        
%     if p==3    
%         max_Val=0.5;
%         min_Val=0;
%         slope=(0-0.75)/(max_Val-min_Val);
%         y_value=0.75-slope*min_Val;      
%         
%         curvatures(1,1)=curvatures(end-1,1);
%         curvatures(end,1)=curvatures(2,1);
%         for i=2 : length(px)-1
%             curvatures(i,2)=(curvatures(i-1,1)+curvatures(i,1)+curvatures(i+1,1))/3;
%         end
%         for l=1:2
%             curvatures(1,2)=curvatures(end-1,2);
%             curvatures(end,2)=curvatures(2,2);
%             for i=2 : length(px)-1
%                 curvatures(i,2)=(curvatures(i-1,2)+curvatures(i,2)+curvatures(i+1,2))/3;
%             end
%         end
%         
% %         Two times smoothing. This value is arbitrary and maybe has to be
% %         adjusted
%         for i=2 : length(px)-1        
%         h=curvatures(i,2)*slope+y_value;
%         if h>1
%             h=1;
%         end
%         if h<0
%             h=0;
%         end
%         rgb_val=hsv2rgb([h,1.0,1.0]);
%         plot([(px(i)+px(i-1))/2 (px(i+1)+px(i))/2], [(py(i)+py(i-1))/2 (py(i+1)+py(i))/2], 'Color', rgb_val, 'LineWidth', 3);                
%         end
%     end       
        x=Particle(k,p,1);
        y=Particle(k,p,2);
        part=PixSeparated_Lab(y,x,p);
        
        if num_K>0 && part>0
            av_curvature(p,part)=av_K/num_K;
            max_curvature(p,part)=max_K;
            min_curvature(p,part)=min_K;
        end
    end
    if p==3   
%         min(min_curvature(p,:))
%         max(max_curvature(p,:))
        Plot_over_micrograph(max_curvature,PixSeparated,m,n,FolderPath,File,min(max_curvature(p,:)), max(max_curvature(p,:)));
    end    
end    
