function [Triple_points] = Triple_point_density(CombinedMicrostructure,m,n)
Triple_points=zeros(2,1);
Neighbors=zeros(3,1);
for i=1:m-1
    for j=1:n-1
        Neighbors(CombinedMicrostructure(i,j),1)=1;
        Neighbors(CombinedMicrostructure(i+1,j),1)=1;
        Neighbors(CombinedMicrostructure(i,j+1),1)=1;
        Neighbors(CombinedMicrostructure(i+1,j+1),1)=1;
        if sum(Neighbors(:,1) == 1) == 3
            Triple_points(1,1)=Triple_points(1,1)+1;
        end
        Neighbors=zeros(3,1);
    end    
end

Triple_points(2,1)=Triple_points(1,1)/(m*n);
