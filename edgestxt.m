%this functions takes the protocol file,img matrix, bg matrix and the binary mask to 
%outputs f, subbaseF and int.

function [avgint,sbF,inte,delf,delfof,rsq,SNR] = edgestxt(imgfile,mask_kv,num2,bgmask,protocol)

[ParentDir, filename]=getfilename(imgfile);%to get tiff name and parent directory
DataPath=imgfile;

mask=mask_kv;
info=imfinfo(DataPath);
numimages=numel(info); %computes number of frames of movie @ numimages
height=info.Height;
width=info.Width;

matprot=protocol;
adj=3;%adj is how much give.
num=num2; %number of steps.

%in the next two lines of code we adjust the given indices in matprot
matprot(1:2:end)=matprot(1:2:end)+adj;
matprot(2:2:end)=matprot(2:2:end)-adj;

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


%avgint is the matrix of average intensities of each stimulation epoch
avgint=avgintensity2(averageintbgsub,matprot);
%sbF is the matrix of average intensities of each baseline fluorescence
%between the stim epochs
[sbF,sbmat]=subbaseF2(averageintbgsub,matprot,adj);
%inte is the matrix of indices (midpt of the stim epochs)
inte=intervaldx(matprot);
intesb=intervaldx(sbmat);

delf=avgint-sbF;
delfof=delf./sbF;

delfint=zeros(1,numimages);
delfofint=zeros(1,numimages);
counter=1;
counter2=1;
for k=1:numimages
    if k<matprot(2*counter+1) && k<matprot(length(matprot)-1)
        delfint(k)=averageintbgsub(k)-sbF(counter);
    elseif k>=matprot(2*counter+1) && k<matprot(length(matprot)-1)
        counter=counter+1;
        delfint(k)=averageintbgsub(k)-sbF(counter);
    else
        delfint(k)=averageintbgsub(k)-sbF(length(sbF));
    end
end

%delfint(delfint<0)=0;

for c=1:numimages
    if c<matprot(2*counter2+1) && c<matprot(length(matprot)-1)
        delfofint(c)=(delfint(c))/(sbF(counter2));
    elseif c>=matprot(2*counter2+1) && c<matprot(length(matprot)-1)
        counter2=counter2+1;
        delfofint(c)=(delfint(c))/(sbF(counter2));
    else
        delfofint(c)=(delfint(c))/sbF(length(sbF));
    end
end

%converts the rising and falling edges of the intervals used to get the average intensities to on-off plateaus.
%height of "on" is the first average intensity step (F bg sub)
%height on "off" is the last average intensity step
binarymat=steps(matprot)*avgint(1);
binarymat(binarymat==0)=avgint(num);

%converts the intervals used to get the sub-base F average intensities to on-off plateaus.
%height of "on" is the first average delta F
%height on "off" is the last average delta F
stepsb=steps(sbmat);
binarysbmat=stepsb*delf(1);
binarysbmat(binarysbmat==0)=delf(num);

standev=std(nonzeros(stepsb.*delfofint(1:length(stepsb))));
SNR=delfof(4)/standev;

plotdelfof=fliplr(delfof);

%obtaining the best fit line
if num==21
    volt=[-300 -270 -240 -210 -180 -150 -120 -90 -60 -30 0 30 60 90 120 150 180 210 240 270 300];
else
    volt=[-100 -80 -60 -40 -20 0 20 40 60 80 100];
end

p = polyfit(volt,plotdelfof,1);
yfit = polyval(p,volt);
yresid = plotdelfof - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(delfof)-1) * var(delfof);
rsq = 1 - SSresid/SStotal;

figure;

subplot(4,1,1);
plot(averageint);
xlim([0 sbmat(length(sbmat))+10]);
title('Raw F');
xlabel('Timepoints');
ylabel('Fluorescence');
subplot(4,1,2);
plot(averageintbgsub);
xlim([0 sbmat(length(sbmat))+10]);
hold on;plot(binarymat,'black');
hold on;scatter(inte,avgint,'o','red');
hold on;scatter(intesb,sbF,'*','green');
title('Background-subtracted Fluorescence');
xlabel('Timepoints');
ylabel('Fluorescence');
subplot(4,1,3);
plot(delfint);
xlim([0 sbmat(length(sbmat))+10]);
hold on;plot(binarysbmat,'black');
title('\Delta F');
xlabel('Timepoints');
ylabel('\Delta F');
subplot(4,1,4);
plot(delfofint);
xlim([0 sbmat(length(sbmat))+10]);
hold on;scatter(inte,delfof,'o','red');
title('\Delta F/F');
xlabel('Timepoints');
ylabel('\Delta F/F');
saveas(gcf, [ParentDir,filesep,filename,'_Fluorescence'],'jpg');

%{
figure;
scatter(inte,delfof,'o');
hold on; plot(inte,yfit);
title('\Delta F/F');
xlabel('Timepoints');
ylabel('\Delta F/F');
saveas(gcf, [ParentDir,filesep,filename,'_Delta_F_over_F'],'jpg');
%}

xtext=volt(length(volt)-2);
ytext=plotdelfof(length(plotdelfof)-3);
ytext2=plotdelfof(length(plotdelfof)-4);


figure;
scatter(volt,plotdelfof,'o');
hold on; plot(volt,yfit);
title('\Delta F/F versus Voltage');
xlabel('Voltage (mV)');
ylabel('\Delta F/F');
text(xtext,ytext,strcat('R^2 = ',num2str(rsq)));
text(xtext,ytext2,strcat('SNR = ',num2str(SNR)));
saveas(gcf, [ParentDir,filesep,filename,'_Delta_F_over_F_Voltage'],'jpg');

end