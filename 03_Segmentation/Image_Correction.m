function [PixSeparated] = Image_Correction(PixSeparated,m,n,Correction_Algorithms,Parameters_for_correction,PhasesToAnalyze)

for i=1:size(Correction_Algorithms,2)
    j=Correction_Algorithms(i);
    if j==1
        [PixSeparated] = Gray_border_reduction_Elizabeth(PixSeparated,m,n);
    elseif j==2
        [PixSeparated] = Gray_border_reduction_Elizabeth_adjusted(PixSeparated,m,n);
    elseif j==3
        [PixSeparated] = Gray_border_reduction_neighbor_adjusted(PixSeparated,m,n,Parameters_for_correction(1),Parameters_for_correction(2));
    elseif j==4
        changed_pixels=1;
        while changed_pixels>0
            [PixSeparated,changed_pixels] = Gray_border_reduction_neighbor(PixSeparated,m,n);
        end
    elseif j==5
        if Parameters_for_correction(3)~=0
            minimumsize = Parameters_for_correction(3);
        else
            LowBound = zeros(3);
            close all;
            for k = 1:3
                if ~PhasesToAnalyze(k)
                    continue
                else
                    PhaseInterior = imclearborder(PixSeparated(:,:,k),4);
                    LabelInterior = bwlabel(PhaseInterior);
                    IntAreas = regionprops('table',LabelInterior,'area');
                    
                    [AreaNum,~] = size(IntAreas);
                    AreaArray = zeros(AreaNum,1);
                    for a = 1:AreaNum
                        AreaArray(a) = IntAreas.Area(a);
                    end
                    
                    histogram(AreaArray);
                    questdlg('Use this histogram to determine a lower bound for region area in pixels. NOTE: Any spikes are likely due to artifacts and should be disregarded.','Area Distribution','OK','Cancel','OK');
                    Low = str2double(cell2mat(inputdlg(sprintf('Minimum area of phase %d regions (pixels):', k), ...
                        'Boundary setting')));
                    LowBound(k) = Low;
                    close all;
                end
            end
            minimumsize = min(LowBound(LowBound>0));
        end
        changed_pixels=1;
        while changed_pixels>0
            [PixSeparated,changed_pixels] = Small_region_correction(PixSeparated, minimumsize);
        end
    else
        warning('Unexpected behavior')
    end
end