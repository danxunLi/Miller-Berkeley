%imgfile=data path of the movie
%outputs indices of rising and falling edges (ind) and subF
function [ind,averageintbgsub,averageint,numimages]=epochs(imgfile,mask,bgmask,num)

DataPath=imgfile;

info=imfinfo(DataPath);
numimages=numel(info); %computes number of frames of movie @ numimages
height=info.Height;
width=info.Width;

amat=zeros(1,numimages);
averageint=zeros(1,numimages);
averageintbgsub=zeros(1,numimages);
newmat=zeros(height,width,numimages+5);
newmat2=zeros(height,width,numimages+5);
%newmat contains the masked raw intensities and newmat2 contains the masked
%raw intensities post background subtraction.
for j=1:numimages
    A=imread(DataPath, j);
    newmat(:,:,j)=int16(A.*mask);%int16 so that can register negative numbers
    newmat2(:,:,j)=int16(A.*mask)-mean(nonzeros(int16(A.*uint16(+bgmask)))); %apply mask to each frame
    C=newmat2(:,:,j);
    C(C<0)=0;
    newmat2(:,:,j)=C;
end

d=1;
ind=zeros(1,50);%inde number

%tit represents the threshold value that is the cut off.
%if the result has a straight region that doesn't really join up with the
%ends, then the cut off is too high: adjust lower.
%if the result is jumbled, or if get error message "index out of bounds"
%then the cut off is too low: adjust higher.
if num==11
    %tit=2;
    tit=1.5;
else
    tit=5;
    %tit=3.5;
    %tit=6;
    
end

for k=1:numimages
    priframe = newmat(:,:,k); 
    nexframe = newmat(:,:,k+2); %compare to the second to avoid build
    maxchg=abs((nexframe-priframe)); %maxchg is a matrix of all the abs val differences
    chg=mean(mean((nonzeros(maxchg)))); %the largest intensity pixel difference bw frame A3 and A4 is saved @chg
    amat(k)=chg; %amat is an array of intensity changes = rising and falling edges
    
    if amat(k)/amat(1)>tit
        ind(d)=k;%ind registers the indices that correspond to a large intenity change.
        d=d+1;
    end
    averageint(k)=mean(nonzeros(newmat(:,:,k)));%averageint is the array of average intensities of the masked image
    averageintbgsub(k)=mean(nonzeros(newmat2(:,:,k))); %averageint is the array of average intensities of the masked image with bg substraction
end

plot(amat);
hold on;
scatter(nonzeros(ind),amat(nonzeros(ind)),'g','.');


end