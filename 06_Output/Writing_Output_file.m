function Writing_Output_file(FolderPath,File,micropix,Sharpen,Segmentation_split,Correction_Algorithms,Parameters_for_correction,Boundary_comp)


f=fopen(sprintf('%s_Parameters.txt',char(strcat(FolderPath,'\',File(1)))),'w');
fprintf(f,'Calculated on %s;\n',datetime);
fprintf(f,'Scale: %d micrometers per pixel;\n',micropix);
fprintf(f,'Sharpening: radius = %d, amount = %d;\n',Sharpen(1),Sharpen(2));
fprintf(f,'Segmentation split: %d rows, %d columns;\n',Segmentation_split(2),Segmentation_split(1));
fprintf(f,'Neighbor-based correction (newer): radius = %d, fraction = %d;\n',Parameters_for_correction(1),Parameters_for_correction(2));
fprintf(f,'Correction algorithm sequence:');
for i=1:size(Correction_Algorithms,2)
    j = Correction_Algorithms(i);
    if j==1
        fprintf(f,' erode-dilate (older),');
    elseif j==2
        fprintf(f,' erode-dilate (newer),');
    elseif j==3
        fprintf(f,' neighbor-based (newer),');
    elseif j==4
        fprintf(f,' neighbor-based (older),');
    elseif j==5
        fprintf(f,' small area correction,');
    else
        warning('Unexpected behavior');
    end
end
fprintf(f,';\nMinimum allowed particle size: %d', Parameters_for_correction(3));
fclose(f);