function [Mat_av_if_length_mu,Mat_av_if_length_relative_mu,Mat_dist_average_mu,Mat_Area_mu,Mat_Major_axes_mu,Mat_Minor_axes_mu,Mat_average_Axes_length_mu,Triple_points_mu] = Calculation_to_microns(micropix,Mat_av_if_length,Mat_av_if_length_relative,Mat_dist_average,Mat_Area,Mat_Major_axes,Mat_Minor_axes,Mat_average_Axes_length,Triple_points)


Mat_av_if_length_mu(:,1)=Mat_av_if_length(:,1)*micropix;
Mat_av_if_length_relative_mu(:,1)=Mat_av_if_length_relative(:,1)/micropix;
Mat_dist_average_mu=Mat_dist_average*micropix;
Mat_Area_mu=Mat_Area*micropix*micropix;
Mat_Major_axes_mu=Mat_Major_axes*micropix;
Mat_Minor_axes_mu=Mat_Minor_axes*micropix;
Mat_average_Axes_length_mu=Mat_average_Axes_length*micropix;
Triple_points_mu(2,1)=Triple_points(2,1)/(micropix*micropix);
Triple_points_mu(1,1)=Triple_points(1,1);