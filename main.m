%% SETUP
input_file = which('Input.txt');

PhasesToAnalyze=[1,1,1];

%% INPUT HANDLING
raw_input_data = readtable(input_file,'delimiter',';');
input_data = rename_variables(raw_input_data);
input_data.path = fileparts(input_file);
input_data.filename = input_data.filename{1};
sp = input_data.sharpening_parameters{1};
sp = strsplit(sp,',');
sp = str2double(sp);
input_data.sharpening_parameters = struct();
input_data.sharpening_parameters.radius = sp(1);
input_data.sharpening_parameters.amount = sp(2);

image = read_image(input_data);

%% SHARPENING
prepared_image = prepare_image(image,input_data.sharpening_parameters);

%% OTHER STUFF

% % % % % % % % % %
% Segmentation    %
% % % % % % % % % %
% Initial Segmentation without without correction
[PixSeparated] = Segmentation(prepared_image,m,n,Segmentation_split(1),Segmentation_split(2));

% Applying the correction algorithms
[PixSeparated] = Image_Correction(PixSeparated,m,n,Correction_Algorithms,Parameters_for_correction,PhasesToAnalyze);
CombinedMicrostructure=PixSeparated(:,:,1)+2*PixSeparated(:,:,2)+3*PixSeparated(:,:,3);

imwrite(PixSeparated,sprintf('%s_segmented.png',char(strcat(FolderPath,'\',File(1)))));
if Boundary_comp(1)==1
    Boundary_comparison_2(FolderPath,File,PixSeparated,m,n);
    close all
end

% % % % % % % % % %
%    Analysis     %
% % % % % % % % % %

% Gives the number of triple ploints and the triple point density
Triple_points = Triple_point_density(CombinedMicrostructure,m,n);

% Gives the density map (Very compute intensive)
%     [Distance_map] = Border_distance(PixSeparated,m,n,FolderPath,File);

% Phase fractions
phase_fractions = compute_phase_fractions(CombinedMicrostructure);

% Average interface length
% The interface orientation is a histogram with the bin size 10 degrees
[Mat_av_if_length,Mat_av_if_length_relative,Mat_angles_rel_hist]=Interface_Length(PixSeparated,CombinedMicrostructure,m,n);

% Centroid spacings
[Mat_dist_average,spacing_dist]= Lamellar_Spacings(CombinedMicrostructure,PhasesToAnalyze,PixSeparated);

% Nearest neighbor statistics (the first value in the matrix means no
% neighbour)
MaxNumNeighbors=15;
[Mat_Nearest_Neighbours]= Neighbours(CombinedMicrostructure,PixSeparated,MaxNumNeighbors);

% Particle size
% Length of the major axis of the ellipse that has the same normalized second central moments as the particle,
% Length of the minor axis of the ellipse that has the same normalized second central moments as the particle
%Orientation of the ellipses with the same normalized second central moments as the particle
% Note that, for phases with fewer than the maximum number of regions,
%  some cells in the output csv list an area of 0.
[Mat_Area,Mat_Major_axes,Mat_Minor_axes,Mat_Orientations,Mat_average_Axes_length] = RegionStats(PixSeparated,m,n);

% Aspect ratio between the minor and the major axis
Mat_AspectRatio = zeros(3,size(Mat_Major_axes,2));
for i = 1:3
    for j = 1:size(Mat_Major_axes,2)
        Mat_AspectRatio(i,j) = Mat_Major_axes(i,j)/Mat_Minor_axes(i,j);
    end
end

% Shape factor
[Mat_average_shape_factor]=Shape_factor(PixSeparated,m,n);

%     max_dist=100;
%     Phase=3;
%     Plot_Ordering(PixSeparated,m,n,max_dist,Phase,FolderPath,File)

% Shape factor based on the second moment of inertia and the moment
% invariants
[Matrix_Moment_Invariants_Shape_Factors] = Moment_Invariants_Shape_factor(CombinedMicrostructure,PixSeparated,m,n,FolderPath,File);

% Curvature
[av_curvature,max_curvature,min_curvature] = Curvature(PixSeparated,m,n,FolderPath,File);

% % % % % % % % % %
% Postprocessing  %
% % % % % % % % % %

% Calculation of the results in micrometer
[Mat_av_if_length_mu,Mat_av_if_length_relative_mu,Mat_dist_average_mu,Mat_Area_mu,Mat_Major_axes_mu,Mat_Minor_axes_mu,Mat_average_Axes_length_mu,Triple_points_mu] = Calculation_to_microns(micropix,Mat_av_if_length,Mat_av_if_length_relative,Mat_dist_average,Mat_Area,Mat_Major_axes,Mat_Minor_axes,Mat_average_Axes_length,Triple_points);

% Plots the microstructure in a graph representation
%     Graph(CombinedMicrostructure,PixSeparated,MaxNumNeighbors,FolderPath,File);

% % % % % % % % % %
%     Output      %
% % % % % % % % % %

% Backup of the used parameters
Writing_Output_file(FolderPath,File,micropix,Sharpen,Segmentation_split,Correction_Algorithms,Parameters_for_correction,Boundary_comp);

% Writing out the results in a csv file
Writing_Out_Data(FolderPath,File,phase_fractions,Mat_av_if_length_mu,Mat_av_if_length_relative_mu,Mat_angles_rel_hist,Mat_dist_average_mu,Mat_Nearest_Neighbours,Mat_Area_mu,Mat_Major_axes_mu,Mat_Minor_axes_mu,Mat_Orientations,Mat_AspectRatio,Mat_average_Axes_length_mu,Mat_average_shape_factor,av_curvature,max_curvature,min_curvature,Matrix_Moment_Invariants_Shape_Factors,Triple_points_mu)
fclose(input_data);