function B=time2num(A)
%ʹ��ʱ��Ԫ������A��Ϊ��ֵ�͵�B
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