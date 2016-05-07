function [c,clusterarr] = clusterdxl(index)

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
c=[];
for i=1:counter
    c(i)=clusterarr{i}{1};
end
    
end
