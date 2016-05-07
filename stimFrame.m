function [frame] = stimFrame(imgfile)
%ignore;artifactfromsummerDataPath='D:\Marcus\MarcusAnalysis\ArCh1\ArCh1-0531\ArCh1_0531_recording-1';
DataPath=imgfile;

chgrecord=0;
frame=1;

for k=1:50
    A3 = imread(DataPath, k); 
    A4 = imread(DataPath, k+2); %compare to the second to avoid build
    maxchg=abs(A4-A3); %maxchg is a matrix of all the abs val differences
    chg=max(max(maxchg)); %the largest intensity pixel difference bw frame A3 and A4 is saved @chg 
    a(k)=chg;
    if (chg>chgrecord)
        chgrecord=chg; %chgrecord is the largest intensity difference from 1-50 
        frame=k+7;
    end
end