%inputs the matrix of indices of rising and falling edgs and outputs the
%middle index for each interval
function [matrixint]=intervaldx(matrix)
mat=matrix;
matrixint=zeros(1,length(mat)/2);
for i=1:(length(mat)/2)
    matrixint(i)=(mat(2*i-1)+mat(2*i))/2;
end
end
