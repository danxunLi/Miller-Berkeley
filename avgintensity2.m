%inputs subF, matrix of indices, and interval respectively
%outputs matrix of average intensity for each interval of stimulation
function [avgint]=avgintensity2(intmat,indmat)

res=intmat;
avgint=zeros(1,length(indmat)/2);
for j=1:(length(indmat)/2)
    interval=indmat(2*j)-indmat(2*j-1)+1;
    avgint(j)=sum(res(indmat(2*j-1):indmat(2*j)))/interval;
end
end