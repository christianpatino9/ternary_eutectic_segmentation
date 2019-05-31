function Plot_Ordering(PixSeparated,m,n,max_dist,Phase,FolderPath,File)
% This analyis method is based on Dennstedt et al. "New metallographic method for estimation of ordering and lattice parameter in ternary eutectic systems." Metallography, Microstructure, and Analysis 2.3 (2013): 140-147.


PixSeparatedLab=zeros(m,n);
PixSeparatedLab(:,:)=bwlabel(imclearborder(PixSeparated(:,:,Phase),4),4);

max_num_particles=max(max(max(PixSeparatedLab)));
Barycenter = regionprops('table',PixSeparatedLab(:,:),'Centroid');

gray=[0.5 0.5 0.5];
viscircles([0,0],[round(max_dist)],'Color',gray','LineWidth',0.5);
hold on;
viscircles([0,0],[round(max_dist/2)],'Color',gray,'LineWidth',0.5);
hold on;
viscircles([0,0],[round(max_dist/4*3)],'Color',gray,'LineWidth',0.5);
hold on;
viscircles([0,0],[round(max_dist/4)],'Color',gray,'LineWidth',0.5);
hold on;
plot([0,0],[-max_dist,max_dist],'Color',gray,'LineWidth',0.5);
hold on;
plot([-max_dist,max_dist],[0,0],'Color',gray,'LineWidth',0.5);
hold on;

pos_x=sin(pi/180*30)*max_dist;
pos_y=cos(pi/180*30)*max_dist;
plot([pos_x,-pos_x],[pos_y,-pos_y],'Color',gray,'LineWidth',0.5);
hold on;
plot([pos_y,-pos_y],[pos_x,-pos_x],'Color',gray,'LineWidth',0.5);
hold on;
plot([-pos_x,pos_x],[pos_y,-pos_y],'Color',gray,'LineWidth',0.5);
hold on;
plot([-pos_y,pos_y],[pos_x,-pos_x],'Color',gray,'LineWidth',0.5);
hold on;

pbaspect([1 1 1])
for i=1:max_num_particles
    x1=Barycenter.Centroid(i,1);
    y1=Barycenter.Centroid(i,2);
    for j=1:max_num_particles
        x2=Barycenter.Centroid(j,1);
        y2=Barycenter.Centroid(j,2);
        d=sqrt((x1-x2)^2+(y1-y2)^2);
        if d>0.1 && d<=max_dist
            plot(-(x2-x1), y2-y1,'ko','MarkerSize',2);
            hold on;
        end
    end
end    

viscircles([0,0],[56.7624],'Color',[1 0 0],'LineWidth',1.5);
hold on;
viscircles([0,0],[37.5103],'Color',[0 0 1],'LineWidth',1.5);
hold on;

