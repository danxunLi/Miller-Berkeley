function [matprot,interval,firstheight] = edgestxtnew(imgfile,mask_kv,num2,bgmask)

DataPath=imgfile;

mask=mask_kv;
info=imfinfo(DataPath);
numimages=numel(info); %computes number of frames of movie @ numimages
height=info.Height;
width=info.Width;

matprot=load('prot.txt');
adj=3;%adj is how much give.
num=num2; %number of steps.
matprot(1:2:end)=matprot(1:2:end)+adj;
matprot(2:2:end)=matprot(2:2:end)-adj;

%{

%specifiying the indices for rising and falling edges
matprot=zeros(1,2*num);

%Ali's protocol

for i=1:num
    matprot(2*i-1)=100*(i-1)+25+adj;
    matprot(2*i)=75+(i-1)*100-adj;
end
%}

%Rishi's protocol
%{
for i=1:num
    matprot(2*i-1)=100*(i-1)+25+adj;
    matprot(2*i)=100*(i-1)+50-adj;
end
%}

%amat=zeros(1,numimages);
averageint=zeros(1,numimages);
averageintbgsub=zeros(1,numimages);

newmat=zeros(height,width,numimages);
newmat2=zeros(height,width,numimages);
%newmat contains the masked raw intensities 
%newmat2 contains the masked raw intensities post background subtraction.
for j=1:numimages
    A=imread(DataPath, j);
    newmat(:,:,j)=int16(A.*mask);%int16 so that can register negative numbers
    newmat2(:,:,j)=int16(A.*mask)-mean(nonzeros(int16(A.*uint16(+bgmask)))); %apply mask to each frame
    C=newmat2(:,:,j);
    C(C<0)=0;
    newmat2(:,:,j)=C;
end

for k=1:numimages
    averageint(k)=mean(nonzeros(newmat(:,:,k)));%averageint is the array of average intensities of the masked image
    averageintbgsub(k)=mean(nonzeros(newmat2(:,:,k))); %averageint is the array of average intensities of the masked image with bg substraction
end



interval=matprot(2)-matprot(1);%the length of each step
period=matprot(3)-matprot(1);%the period between each step

%avgint is the matrix of average intensities of each stimulation epoch
avgint=avgintensity2(averageintbgsub,matprot);
%sbF is the matrix of average intensities of each baseline fluorescence
%between the stim epochs
sbF=subbaseF2(averageintbgsub,matprot,adj);
%inte is the matrix of indices (midpt of the stim epochs)
inte=intervaldx(matprot);

firstheight=avgint(1);

binarymat=steps(matprot)*avgint(1);%converts the rising and falling edges to on-off plateaus.
binarymat(binarymat==0)=avgint(num);

figure;
subplot(2,1,1);
plot(averageint);
title('Raw F');
subplot(2,1,2);
plot(averageintbgsub);hold on;plot(binarymat);
title('Background-subtracted F');

delf=avgint-sbF;
delfof=delf./sbF;
figure;
scatter(inte,delfof,'o');
title('\Delta F/F');
xlabel('Timepoints');
ylabel('\Delta F/F');

end