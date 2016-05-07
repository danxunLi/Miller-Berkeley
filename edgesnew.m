%takes a mask to feed to epochs to find the rising and falling edges
%indices which are fed into matcompri and the raw intensities of
%everything, which is fed into res. 
%num is number of steps, ~11, which includes both high and low intensities.
function [matcompri,matedges,matintv,mat,interval,firstheight] = edgesnew(imgfile,mask,num,bg)
DataPath=imgfile;
len=num;%len/num= number of data points
bgmask=bg;

[matcompri,avgintbgsub,avgintensitymat]=epochs(DataPath, mask,bgmask); %matcompri=matrix of all indices of rising and falling edges, res=subF

mat=[];
 matcomp=nonzeros(matcompri);
lencomp=length(matcomp);

for i=1:length(find(matcomp<50))
    mat(i)=matcomp(i);
end

lenmat=length(mat);
matintv=[];

for i=1:(lencomp-lenmat)
    matintv(i)=matcomp(lenmat+i);
end

interval=matintv(1)-mat(lenmat);%interval = length of stimulation

permat=[];
arrc=find(matcomp>matintv(1)+10);
for i=1:length(arrc)
    permat(i)=matcomp(arrc(i));
end

period=permat(1)-mat(1);%period = time from start of one stimulation to start of next stimulation
matedges=zeros(1,len*2);

matedges(1)=mat(1)+3;%matedges is the array of single-value indices of the rising and falling edges
matedges(2)=matedges(1)+interval;
for j=2:len
    matedges(2*j-1)=matedges(2*j-3)+period;
    matedges(2*j)=matedges(2*j-1)+interval;
end

%avgint is the matrix of average intensities of each stimulation epoch
avgint=avgintensity(avgintbgsub,matedges,interval);
%sbF is the matrix of average intensities of each baseline fluorescence
%between the stim epochs
sbF=subbaseF(avgintbgsub,matedges,period);
%inte is the matrix of indices (midpt of the stim epochs)
inte=intervaldx(matedges);

firstheight=avgint(1);

%figure;
%scatter(inte,avgint);
binarymat=steps(matedges)*avgint(1);
binarymat(binarymat==0)=avgint(num);

figure;
subplot(2,1,1);
plot(avgintensitymat);
title('Raw F');
subplot(2,1,2);
plot(avgintbgsub);hold on; plot(binarymat);
title('Background-subtracted F');
end