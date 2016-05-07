function [avgbaseF,subBFmat]=subbaseF2(allint,matprot,give)
adj=give;
mat=matprot;%all the rising and falling edges with give.
res=allint;%the matrix of bg-subtracted intensities
lenmat=length(mat);
intv=mat(3)-mat(2)-4*adj; %just used at the end
%first get all the indices that correspond to each subbaseF interval.
subBFmat=zeros(1,lenmat);
for j=1:lenmat
    if j<lenmat && mod(j,2)%all odd indices
        subBFmat(j)=mat(j+1)+2*adj;
    elseif j<lenmat %all even indices
        subBFmat(j)=mat(j+1)-2*adj;
    else
        subBFmat(j)=subBFmat(j-1)+intv;
    end
end

avgbaseF=zeros(1,lenmat/2);
for j=1:(lenmat/2)
    interval=subBFmat(2*j)-subBFmat(2*j-1)+1;
    avgbaseF(j)=sum(res(subBFmat(2*j-1):subBFmat(2*j)))/interval;
end
%avgbaseF is an array of the intensities of the baseline fluorescence
%between stimulation epochs (to correct for fluctuating baselines.

end
