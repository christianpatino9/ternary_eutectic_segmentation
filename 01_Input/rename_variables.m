function input_table = rename_variables( input_table )

vars = input_table.Properties.VariableNames;
vars{ 1 } = 'filename';
vars{ 2 } = 'px_per_um';
vars{ 3 } = 'sharpening_parameters';
vars{ 4 } = 'segmentation_window_count';
vars{ 5 } = 'segmentation_corrections';
vars{ 6 } = 'segmentation_correction_parameters';
vars{ 7 } = 'generate_boundary_image';
input_table.Properties.VariableNames = vars;

end

