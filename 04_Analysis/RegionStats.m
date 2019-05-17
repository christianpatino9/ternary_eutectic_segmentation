function [Area_stats,Major_axes,Minor_axes,Orientations,average_Axes_length] = RegionStats(PixSeparated,m,n)

PixSeparatedLab=zeros(m,n,3);

for i = 1:3
  PixSeparatedLab(:,:,i)=bwlabel(imclearborder(PixSeparated(:,:,i),4),4);
end

max_num_particles=max(max(max(PixSeparatedLab)));
Area_stats = zeros(3,max_num_particles);
Major_axes = zeros(3,max_num_particles);
Minor_axes = zeros(3,max_num_particles);
Orientations = zeros(3,max_num_particles);
Barycenter = zeros(3,2,max_num_particles);
Axes_lengths = zeros(3,2,max_num_particles);

for i = 1:3
  PhaseStats = regionprops('table',PixSeparatedLab(:,:,i),'area','Centroid','MajorAxisLength','MinorAxisLength','Orientation');
    for j = 1:size(PhaseStats,1)
        Area_stats(i,j)=PhaseStats.Area(j);
        Barycenter(i,1,j)=PhaseStats.Centroid(j,1);
        Barycenter(i,2,j)=PhaseStats.Centroid(j,2);
        Major_axes(i,j)=PhaseStats.MajorAxisLength(j);
        Minor_axes(i,j)=PhaseStats.MinorAxisLength(j);
        Orientations(i,j)=PhaseStats.Orientation(j);
    end
end



% Calculating the major and minor acis where it really hits the boundary
for i = 1:3
    for j = 1:max_num_particles
        x=round(Barycenter(i,1,j));
        y=round(Barycenter(i,2,j));
        if x>0 && y>0 
%             disp([num2str(x),' ',num2str(y),' ',num2str(PixSeparatedLab(y,x,i)),' ',num2str(j)]);
            if PixSeparatedLab(y,x,i) == j
                m=-tan(Orientations(i,j)*pi/180);
                b_1=0;
                b_2=0;
                b_3=0;
                b_4=0;
                if m<=1 && m>=-1
                    % Major axis
                    b=Barycenter(i,2,j);
                    x_pos=x;
                    while b_1==0
                        y_pos=round(m*(x_pos-x)+b);
                        if PixSeparatedLab(y_pos,x_pos,i) ~= PixSeparatedLab(y,x,i)
                            b_1=1;
                            Axes_lengths(i,1,j)=sqrt((x_pos-1/2-x)^2+(round(m*(x_pos-1/2-x)+b)-y)^2);
%                             disp(['If Upper Maj ',num2str(m),' ',num2str(b),' ',num2str(x),' ',num2str(y),' ',num2str(x_pos),' ',num2str(y_pos)]);
                        end    
                        x_pos=x_pos+1;
                    end  
                    x_pos=x;
                    while b_2==0
                        y_pos=round(m*(x_pos-x)+b);
                        if PixSeparatedLab(y_pos,x_pos,i) ~= PixSeparatedLab(y,x,i)
                            b_2=1;
                            Axes_lengths(i,1,j)=Axes_lengths(i,1,j)+sqrt((x_pos+1/2-x)^2+(round(m*(x_pos+1/2-x)+b)-y)^2);
%                             disp(['If Lower Maj ',num2str(m),' ',num2str(b),' ',num2str(x),' ',num2str(y),' ',num2str(x_pos),' ',num2str(y_pos)]);
                        end    
                        x_pos=x_pos-1;
                    end 
                    % Minor axis
                    b=Barycenter(i,1,j);
                    y_pos=y;
                    while b_3==0
                        x_pos=round(-m*(y_pos-y)+b);
                        if PixSeparatedLab(y_pos,x_pos,i) ~= PixSeparatedLab(y,x,i)
                            b_3=1;
                            Axes_lengths(i,2,j)=sqrt((round(m*(y_pos-1/2-y)+b)-x)^2+(y_pos-1/2-y)^2);
%                             disp(['If Upper Min ',num2str(m),' ',num2str(b),' ',num2str(x),' ',num2str(y),' ',num2str(x_pos),' ',num2str(y_pos)]);
                        end    
                        y_pos=y_pos+1;
                    end  
                    y_pos=y;
                    while b_4==0
                        x_pos=round(-m*(y_pos-y)+b);
                        if PixSeparatedLab(y_pos,x_pos,i) ~= PixSeparatedLab(y,x,i)
                            b_4=1;
                            Axes_lengths(i,2,j)=Axes_lengths(i,2,j)+sqrt((round(m*(y_pos+1/2-y)+b)-x)^2+(y_pos+1/2-y)^2);
%                             disp(['If Lower Min ',num2str(m),' ',num2str(b),' ',num2str(x),' ',num2str(y),' ',num2str(x_pos),' ',num2str(y_pos)]);
                        end    
                        y_pos=y_pos-1;
                    end
                    
                else
                    % Major axis
                    b=Barycenter(i,1,j);
                    y_pos=y;
                    while b_1==0
                        x_pos=round(1/m*(y_pos-y)+b);
                        if PixSeparatedLab(y_pos,x_pos,i) ~= PixSeparatedLab(y,x,i)
                            b_1=1;
                            Axes_lengths(i,1,j)=sqrt((round(1/m*(y_pos-1/2-y)+b)-x)^2+(y_pos-1/2-y)^2);
%                             disp(['Else Upper Maj ',num2str(m),' ',num2str(b),' ',num2str(x),' ',num2str(y),' ',num2str(x_pos),' ',num2str(y_pos)]);
                        end    
                        y_pos=y_pos+1;
                    end  
                    y_pos=y;
                    while b_2==0
                        x_pos=round(1/m*(y_pos-y)+b);
                        if PixSeparatedLab(y_pos,x_pos,i) ~= PixSeparatedLab(y,x,i)
                            b_2=1;
                            Axes_lengths(i,1,j)=Axes_lengths(i,1,j)+sqrt((round(1/m*(y_pos+1/2-y)+b)-x)^2+(y_pos+1/2-y)^2);
%                             disp(['Else Lower Maj ',num2str(m),' ',num2str(b),' ',num2str(x),' ',num2str(y),' ',num2str(x_pos),' ',num2str(y_pos)]);
                        end    
                        y_pos=y_pos-1;
                    end
                    % Minor axis
                    b=Barycenter(i,2,j);
                    x_pos=x;
                    while b_3==0
                        y_pos=round(-1/m*(x_pos-x)+b);
                        if PixSeparatedLab(y_pos,x_pos,i) ~= PixSeparatedLab(y,x,i)
                            b_3=1;
                            Axes_lengths(i,2,j)=sqrt((x_pos-1/2-x)^2+(round(1/m*(x_pos-1/2-x)+b)-y)^2);
%                             disp(['Else Upper Min ',num2str(m),' ',num2str(b),' ',num2str(x),' ',num2str(y),' ',num2str(x_pos),' ',num2str(y_pos)]);
                        end    
                        x_pos=x_pos+1;
                    end  
                    x_pos=x;
                    while b_4==0
                        y_pos=round(-1/m*(x_pos-x)+b);
                        if PixSeparatedLab(y_pos,x_pos,i) ~= PixSeparatedLab(y,x,i)
                            b_4=1;
                            Axes_lengths(i,2,j)=Axes_lengths(i,2,j)+sqrt((x_pos+1/2-x)^2+(round(1/m*(x_pos+1/2-x)+b)-y)^2);
%                             disp(['Else Lower Min ',num2str(m),' ',num2str(b),' ',num2str(x),' ',num2str(y),' ',num2str(x_pos),' ',num2str(y_pos)]);
                        end    
                        x_pos=x_pos-1;
                    end
                end    
            end
        end
    end
end    

average_Axes_length=zeros(3,4);
for i=1:3
    for j=1:max_num_particles
        if Axes_lengths(i,1,j)>0 && Axes_lengths(i,2,j)>0
            average_Axes_length(i,1)=Axes_lengths(i,1,j)+average_Axes_length(i,1);
            average_Axes_length(i,2)=average_Axes_length(i,2)+1;
            average_Axes_length(i,3)=Axes_lengths(i,2,j)+average_Axes_length(i,3);
            average_Axes_length(i,4)=average_Axes_length(i,4)+1;
        end
    end
    average_Axes_length(i,1)=average_Axes_length(i,1)/average_Axes_length(i,2);
    average_Axes_length(i,3)=average_Axes_length(i,3)/average_Axes_length(i,4);
end    
