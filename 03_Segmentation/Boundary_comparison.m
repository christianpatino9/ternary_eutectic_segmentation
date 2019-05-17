function Boundary_comparison(ImagePath,File,PixSeparated)
disp('Test123');

BW = imbinarize(PixSeparated(:,:,2));
BW2 = imbinarize(PixSeparated(:,:,3));
[boundaries] = bwboundaries(BW,4);
[boundaries2] = bwboundaries(BW2,4);

imshow(char(strcat(ImagePath,'/',File(1),'.',File(2))));
hold on
for k = 1:length(boundaries)
  boundary = boundaries{k};
  plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 3);
end
hold on
for k = 1:length(boundaries2)
  boundary = boundaries2{k};
  plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 3);
end

print(sprintf('%s_outline.png',char(strcat(ImagePath,'/',File(1)))),'-dpng')

