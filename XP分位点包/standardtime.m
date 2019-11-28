function output=standardtime(pricesheet_date)
%使得没有加0的日期（如2013/1/4）加0（变2013/01/04）
%分隔符转换：如2013-03-04变为2013/03/04
datestr='aaaaaaaaaa';
for(i=1:length(pricesheet_date))
    datestr=cell2mat(pricesheet_date(i));
    if(length(datestr)<10 && length(datestr)>1)
        if(length(datestr)==8)%月和日都个位
            datestr(10)=datestr(8);
            datestr(7:8)=datestr(6:7);
            datestr(6)='0';
            datestr(9)='0';
        else%月和日有一个是个位
            if(datestr(7)=='/' || datestr(7)=='-')%月是个位
                datestr(10)='/';
                datestr(7:10)=datestr(6:9);
                datestr(6)='0';
            else%日是个位
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