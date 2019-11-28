function [EP_data,EP_date]=getEP(PE_data,PE_date)
%% PE变EP，没啥技术含量
[m,n]=size(PE_data);
for(i=1:m)
    for(j=1:n)
        if(isnan(PE_data(i,j))==0)
            EP_data(i,j)=1/PE_data(i,j);
        else
            EP_data(i,j)=NaN;
        end
    end
end
EP_date=PE_date;
end