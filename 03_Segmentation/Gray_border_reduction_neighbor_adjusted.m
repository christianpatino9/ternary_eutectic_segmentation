function [PixSeparated] = Gray_border_reduction_neighbor_adjusted(PixSeparated,m,n,radius,fraction)


PixSeparated_after=PixSeparated;
CombinedMicrostructure=PixSeparated(:,:,1)+2*PixSeparated(:,:,2)+3*PixSeparated(:,:,3);

for i = radius+1:m-radius
    for j = radius+1:n-radius
        Neighbors=zeros(3,1);
        for k = i-radius:i+radius
            for l = j-radius:j+radius
                Neighbors(CombinedMicrostructure(k,l))=Neighbors(CombinedMicrostructure(k,l))+1;
            end
        end
        if Neighbors(CombinedMicrostructure(i,j))/((2*radius+1)*(2*radius+1))>fraction
            continue
        else
            [val, idx] = max(Neighbors);
            number_maximum_values=0;
            for k=1:3
                if Neighbors(k,1) == val
                    number_maximum_values=number_maximum_values+1;
                end    
            end
            if number_maximum_values==1 && CombinedMicrostructure(i,j) ~= idx
                PixSeparated_after(i,j,CombinedMicrostructure(i,j))=0;
                PixSeparated_after(i,j,idx)=1;
            elseif number_maximum_values>1      
                num=randi([1 2],1,1);
                if num==1 && CombinedMicrostructure(i,j) ~= idx
                    PixSeparated_after(i,j,idx)=1;
                    PixSeparated_after(i,j,CombinedMicrostructure(i,j))=0;
                elseif num==2 && CombinedMicrostructure(i,j) ~= find(Neighbors==val,1,'last')      
                    PixSeparated_after(i,j,find(Neighbors==val,1,'last'))=1;
                    PixSeparated_after(i,j,CombinedMicrostructure(i,j))=0;
                else
                end    
            else
            end 
        end     
    end       
end            
            
PixSeparated=PixSeparated_after;