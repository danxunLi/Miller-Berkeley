function [binarymat]=steps(arr)
stepsarr=arr;
%first create a matrix of zeros of length = last step edge + 50.
lenbinmat=stepsarr(length(stepsarr))+50;
binarymat=zeros(1,lenbinmat);
for j=1:(length(stepsarr)/2)
    binarymat(stepsarr(2*j-1):stepsarr(2*j))=1;
end
end