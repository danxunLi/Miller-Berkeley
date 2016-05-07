%% applyMask2TiffStack(tiff_stack , mask)
% Applies logical mask to all frames of an image stack.
% The mask and the image stack height and width should be the same.
% Returns a masked stack of the same height, width, and length .

function masked_tiff_stack = applyMask2TiffStack(tiff_stack , mask)

  masked_tiff_stack = tiff_stack;
  L = size(tiff_stack , 3);
  for i = 1:L
    masked_tiff_stack(:,:,i) = tiff_stack(:,:,i).*mask;
  end
    
    
    