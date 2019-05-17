function image = prepare_image(image,sharpening_parameters)

radius = sharpening_parameters.radius;
amount = sharpening_parameters.amount;

if amount~=0 && radius~=0
    sharpened = imsharpen(image,'Radius',radius,'Amount',amount);
    image = medfilt2(sharpened,[10 10]);
end

end