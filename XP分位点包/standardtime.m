function output=standardtime(pricesheet_date)
%ʹ��û�м�0�����ڣ���2013/1/4����0����2013/01/04��
%�ָ���ת������2013-03-04��Ϊ2013/03/04
datestr='aaaaaaaaaa';
for(i=1:length(pricesheet_date))
    datestr=cell2mat(pricesheet_date(i));
    if(length(datestr)<10 && length(datestr)>1)
        if(length(datestr)==8)%�º��ն���λ
            datestr(10)=datestr(8);
            datestr(7:8)=datestr(6:7);
            datestr(6)='0';
            datestr(9)='0';
        else%�º�����һ���Ǹ�λ
            if(datestr(7)=='/' || datestr(7)=='-')%���Ǹ�λ
                datestr(10)='/';
                datestr(7:10)=datestr(6:9);
                datestr(6)='0';
            else%���Ǹ�λ
                datestr(10)=datestr(9);
                datestr(9)='0';
            end
        end 
        datestr(5)='/';
        datestr(8)='/';
        pricesheet_date(i)=cellstr(datestr);
    
    end
end
output=pricesheet_date;