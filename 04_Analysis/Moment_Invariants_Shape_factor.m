function [Matrix_Moment_Invariants_Shape_Factors] = Moment_Invariants_Shape_factor(CombinedMicrostructure,PixSeparated,m,n,FolderPath,File)
% This analysis method is based on MacSleyne, J. P., J. P. Simmons, and M. De Graef. "On the use of 2-D moment invariants for the automated classification of particle shapes." Acta Materialia 56.3 (2008): 427-437.

PixSeparatedLab=zeros(m,n,3);

for i = 1:3
  PixSeparatedLab(:,:,i)=bwlabel(imclearborder(PixSeparated(:,:,i),4),4);
end

max_num_particles=max(max(max(PixSeparatedLab)));
Area_stats = zeros(3,max_num_particles);
Barycenter = zeros(3,max_num_particles,2);
Second_moment_area=zeros(3,max_num_particles,3);
Matrix_Moment_Invariants_Shape_Factors=zeros(3,max_num_particles,2);

for i = 1:3
  PhaseStats = regionprops('table',PixSeparatedLab(:,:,i),'area','Centroid','MajorAxisLength','MinorAxisLength','Orientation');
    for j = 1:size(PhaseStats,1)
        Area_stats(i,j)=PhaseStats.Area(j);
        Barycenter(i,j,1)=PhaseStats.Centroid(j,1);
        Barycenter(i,j,2)=PhaseStats.Centroid(j,2);
    end
end

for i=1:m
    for j=1:n
        Phase=CombinedMicrostructure(i,j);
        Particle=PixSeparatedLab(i,j,Phase);
        if Particle>0
            Second_moment_area(Phase,Particle,1)=1/12+(i-Barycenter(Phase,Particle,2))^2+Second_moment_area(Phase,Particle,1);
            Second_moment_area(Phase,Particle,2)=1/12+(j-Barycenter(Phase,Particle,1))^2+Second_moment_area(Phase,Particle,2);
            Second_moment_area(Phase,Particle,3)=-(i-Barycenter(Phase,Particle,2))*(j-Barycenter(Phase,Particle,1))+Second_moment_area(Phase,Particle,3);
%             Iy=1/12+(x-xB)^2;
%         Iz=1/12+(y-yB)^2;
%         Iyz=1/6+(x-xB)*(y-yB);
        end
    end    
end  

for i=1:3
    for j=1:max_num_particles
        if Area_stats(i,j)>0
            w1=Area_stats(i,j)^2/(Second_moment_area(i,j,1)+Second_moment_area(i,j,2));
            w2=Area_stats(i,j)^4/(Second_moment_area(i,j,1)*Second_moment_area(i,j,2)-Second_moment_area(i,j,3)^2);
            Matrix_Moment_Invariants_Shape_Factors(i,j,1)=w1/(2*pi);
            Matrix_Moment_Invariants_Shape_Factors(i,j,2)=w2/(16*pi^2);
        end
    end
end    


% Xedges = [-Inf 0:0.05:1 Inf];
% Yedges = [-Inf 0:0.05:1 Inf];
% h = histogram2(Matrix_Moment_Invariants_Shape_Factors(3,:,1),Matrix_Moment_Invariants_Shape_Factors(3,:,2),Xedges,Yedges,'Normalization','probability','FaceColor','flat');
% % axis([0 1 0 1 0 1],'square');
% axis([0 1 0 1 0 0.15],'square');
% view(320,30);
% pbaspect([1 1 0.7]);
% colorbar;
% saveas(gcf,sprintf('%s_bar.png',char(strcat(FolderPath,'\',File(1)))))
