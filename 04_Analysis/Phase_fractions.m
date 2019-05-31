function [Mat_phase_fractions]=Phase_fractions(CombinedMicrostructure,m,n,Mat_phase_fractions);

for i = 1:m
    for j = 1:n
        
       Mat_phase_fractions(CombinedMicrostructure(i,j),1)=Mat_phase_fractions(CombinedMicrostructure(i,j),1)+1;
    end
end
Mat_phase_fractions=Mat_phase_fractions/(m*n);

