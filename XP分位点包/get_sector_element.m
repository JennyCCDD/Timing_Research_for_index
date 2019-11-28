function [element_stock,element_time]=get_sector_element(sector,update_date)
%% 取得某板块在对应更新日下的成份股
%sector是板块代码，str形式：000016.SH上证50，000300.SH沪深300，000001.SH上证综指，000905.SH中证500
%update_date是对应更新日矢量，cell形式
%%
w=windmatlab;
element_stock={};
element_time={};
for(i=1:length(update_date))
    date=cell2mat(update_date(i));
    [elementHS300]=w.wset('sectorconstituent',['date=',date],['windcode=',sector]);
    if(iscell(elementHS300)==1)
        [m,n]=size(elementHS300);
        element_stock(1:m,i)=elementHS300(1:m,2);
        element_time(i)=elementHS300(1,1);
    end
end
end