function image = read_image(input_data)

filepath = fullfile(input_data.path,input_data.filename);
image = imread(filepath);

end

