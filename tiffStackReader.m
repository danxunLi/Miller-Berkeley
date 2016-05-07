function tiff_stack = tiffStackReader(filename)
    fileInfo = imfinfo(filename);
    
    tiff_stack = zeros(fileInfo(1).Height , fileInfo(1).Width , 1);
    for i=1:numel(fileInfo)
        tiff_stack(:,:,i) = imread(filename , 'Index' , i , 'Info' , fileInfo);
    end
    
