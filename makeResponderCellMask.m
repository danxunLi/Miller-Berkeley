function [mask , MaskedStack ,number_of_pixels] = makeResponderCellMask(filename)

tiffStack= tiffStackReader(filename);

% subplot(5,3,1);
% imshow(imadjust(uint16(tiffStack(:,:,1)))); title('Raw F1');

stimF = stimFrame(filename) % Get the first responding frame

rangeMask = makeRangeFiltFrame(tiffStack(:,:,1)); % Make rangefilt of frame 1

% Average intensity of the responding frames
m2 = tiffStack(:,:,46:56); 

for index = 1:size(m2,3)
   m2(:,:,index) = m2(:,:,index).*rangeMask; 
end

m2 = sum(m2 , 3) ./size(m2 , 3);


% Average intensity of non-responding frames
m1 = tiffStack(:,:,1:10); 
for index = 1:size(m1,3)
   m1(:,:,index) = m1(:,:,index).*rangeMask; 
end

m1 = sum(m1 , 3) ./size(m1 , 3);


m3 = m2 - m1; %subtract: responding frame - frame 1
m3(m3<0) = 0; % get rid of negative pixels
m4 = m3; % a copy
tmp2 = logical(m4); % make the subtract result logical

%thickens objects by adding pixels to the exterior of objects until doing
% so would result in previously unconnected objects being 8-connected:
 tmp2 = bwmorph(tmp2,'clean' );
   tmp2 = bwmorph(tmp2,'spur' );
% This while loop applies bwareaopen with increasing second parameter until
% there's only one object is left in the frame (which would be the
% responding cell):
tmp2 = bwareaopen(tmp2, 1);
m4 = m3.*tmp2;
CC = bwconncomp(m4); % to get number of objects in the frame
n = CC(1).NumObjects; % n is the number of objects
counter = 2;
while n>1
    tmp2 = bwareaopen(tmp2, counter);
    m4 = m3.*tmp2;
    CC = bwconncomp(m4);
    n = CC(1).NumObjects;
    counter = counter+1;
end
mask = m4;
mask = imfill(mask , 'holes');
 
mask = logical(mask);

number_of_pixels = sum(sum(mask));
MaskedStack = applyMask2TiffStack(tiffStack , mask);
mask = uint16(mask);
% after the while loop, m4 contains the result.
figure;
imshow(mask*100000);title('Generated mask of the responding cell');
% subplot(5,3,2);
% imshow(imadjust(uint16(m3)));title('Subtracted Frame before bwareaopen');



