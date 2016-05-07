function [singleindexarray,arr] = clusterdxl(index,numsteps)
num=2*numsteps;
ind=index;
clusterarr={{0}};
counter=1;
nextcounter=2;

clusterarr{counter}={ind(1)};
for i=2:length(ind)
    if ind(i)-ind(i-1)<5
        clusterarr{counter}{nextcounter}=ind(i);
        nextcounter=nextcounter+1;
    else
        counter=counter+1;
        nextcounter=2;
        clusterarr{counter}={ind(i)};
    end
end
%assuming that all the numbers are in pairs
singleindexarray=[];
for i=1:counter
    if mod(i,2)==0%even
        singleindexarray(i)=clusterarr{i}{length(clusterarr{i})};
    else
        singleindexarray(i)=clusterarr{i}{1};
    end
end

interval=round((singleindexarray(2)-singleindexarray(1)+singleindexarray(4)-singleindexarray(3)+singleindexarray(6)-singleindexarray(5))/3);
period=round((singleindexarray(3)-singleindexarray(1)+singleindexarray(5)-singleindexarray(3)+singleindexarray(7)-singleindexarray(5))/3);
 
arr=[];
arr(1)=singleindexarray(1);
count=2;
%run through the single index array to fill in gaps.
for i=2:num
    if mod(i,2)==0%even: check interval
        if (singleindexarray(count)-arr(i-1))<(interval+10)&(singleindexarray(count)-arr(i-1))>(interval-10)
            arr(i)=singleindexarray(count);
            count=count+1;
        else
            arr(i)=arr(i-1)+interval;
        end
    else%odd:check period
        if (singleindexarray(count)-arr(i-2))<(period+10)&(singleindexarray(count)-arr(i-2))>(period-10)
            arr(i)=singleindexarray(count);
            count=count+1;
        else
            arr(i)=arr(i-2)+period;
        end
    end
end
            

end
