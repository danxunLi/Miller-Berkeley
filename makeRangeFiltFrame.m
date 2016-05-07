% this function gets a tiff stack and returns a binary mask
function mask = makeRangeFiltFrame(frame)
 % apply rangefilt to frame #1
 s0=class(frame);
 mask = imclearborder(frame);
 mask = rangefilt(mask); 
  
  mask = rangefilt(mask);

level = multithresh(mask);

seg_I = imquantize(mask,level);
mask = seg_I; 
mask(mask<2) = 0;
%mask(mask<level/2.0) = 0;
%  mask = rangefilt(mask); 
%   for i = 1:1   
%       tmp = reshape(mask , [1 , numel(mask)]);
%       tmp = tmp(tmp~=0);
%       mea = mean(tmp);
%       mask(mask<mea) = 0;
%   end

mask = logical(mask); % make it binary
