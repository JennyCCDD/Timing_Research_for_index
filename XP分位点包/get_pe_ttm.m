function [PE_data,PE_date]=get_pe_ttm(element_stock,update_date,month_date)
%% 返回对应month_date(每个月日历日月末)的板块成份股的PE数据
%% 1.将element_stock扩展为月度的：month_element
%element_stock原来为半年化的，6/30或者12/31更新，这里把它扩展为月度
%举例：2013/6/30日更新的成分，为2013/7到2013/12的成分股
w=windmatlab;
update_date_num=time2num(update_date);%转换为数值形式的时间
month_date_num=time2num(month_date);%转换为数值形式的时间
%制作每一个month_date的指向更新日month_update_date：该日期应该对应哪个更新日
for(i=1:length(month_date_num))
    %查看月日,例如：20181010变成1010
    m_d=rem(month_date_num(i),10000);
    if(m_d>700)%如果是下半年，则是今年6/30更新日
        month_update_date(i)=fix(month_date_num(i)/10000)*10000+630;
    else%如果是上半年，则是去年12/31更新日
        month_update_date(i)=fix(month_date_num(i)/10000-1)*10000+1231;
    end
end
%该日期应该对应第几个更新日
month_update_pointer=zeros(1,length(month_date_num));
for(i=1:length(month_date_num))
    for(j=1:length(update_date_num))
        if(update_date_num(j)==month_update_date(i))
            month_update_pointer(i)=j;
            break;
        end
    end
end
%复制更新日的成分股拓展到月度
for(i=1:length(month_update_pointer))
    if(month_update_pointer(i)~=0)
        month_element(:,i)=element_stock(:,month_update_pointer(i));
    end
end
%% 2.计算每个month_date下的有效成份个数:month_element_num
[m,n]=size(month_element);
for(i=1:n)%对于所有month_date
    month_element_num(i)=0;
    for(j=1:m)%对于所有成分股
        if(isempty(cell2mat(month_element(j,i)))==0)%如果不是空，则有效，有效数加1
             month_element_num(i)= month_element_num(i)+1;
        end
    end
end
%% 3.根据成分股从wind上下载PE数据（ttm）
total_data=[];
for(i=1:n)%对于每个month_date
    
    if(month_element_num(i)>0)%如果该日有成份
        %首先构建第一个输入量：成分股str序列，如‘000001.SZ,000002,SZ,...’
        stock_cell={};
        stock_str=[];
        stock_cell=month_element(1:month_element_num(i),i);
        stock_str=cell2mat(stock_cell(1));
        for(j=2:length(stock_cell))
            stock_str=[stock_str,',',cell2mat(stock_cell(j))];
        end
        %构建第三个输入量：month_date_num字符串形式，如'20190228'
        stock_date=num2str(month_date_num(i));
        %接着从wind提取数据：wss
        data=w.wss(stock_str,'pe_ttm',['tradeDate=',stock_date]);
        if(length(data)<m)%这里注意维度问题，比如上证指数成分数不固定，我们要补足NaN直到最大成份数
            data=[data;zeros(m-length(data),1)*NaN];
        end
    else%如果该日无成份更新
        data=zeros(m,1)*NaN;
    end
    total_data=[total_data,data];
end
PE_data=total_data;
PE_date=month_date';
end