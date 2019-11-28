function B=time2num(A)
%使得时间元组向量A变为数值型的B
A=standardtime(A);
datestr='start';
for(i=1:length(A))
    datestr=cell2mat(A(i));
    if(all(datestr==0))
        B(i)=datestr;
    else
        datestr(5)=[];
        datestr(7)=[];
        B(i)=str2num(datestr);
    end
end
B=B';
end