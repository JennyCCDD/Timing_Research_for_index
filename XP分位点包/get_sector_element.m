function [element_stock,element_time]=get_sector_element(sector,update_date)
%% ȡ��ĳ����ڶ�Ӧ�������µĳɷݹ�
%sector�ǰ����룬str��ʽ��000016.SH��֤50��000300.SH����300��000001.SH��֤��ָ��000905.SH��֤500
%update_date�Ƕ�Ӧ������ʸ����cell��ʽ
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