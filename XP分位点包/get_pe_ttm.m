function [PE_data,PE_date]=get_pe_ttm(element_stock,update_date,month_date)
%% ���ض�Ӧmonth_date(ÿ������������ĩ)�İ��ɷݹɵ�PE����
%% 1.��element_stock��չΪ�¶ȵģ�month_element
%element_stockԭ��Ϊ���껯�ģ�6/30����12/31���£����������չΪ�¶�
%������2013/6/30�ո��µĳɷ֣�Ϊ2013/7��2013/12�ĳɷֹ�
w=windmatlab;
update_date_num=time2num(update_date);%ת��Ϊ��ֵ��ʽ��ʱ��
month_date_num=time2num(month_date);%ת��Ϊ��ֵ��ʽ��ʱ��
%����ÿһ��month_date��ָ�������month_update_date��������Ӧ�ö�Ӧ�ĸ�������
for(i=1:length(month_date_num))
    %�鿴����,���磺20181010���1010
    m_d=rem(month_date_num(i),10000);
    if(m_d>700)%������°��꣬���ǽ���6/30������
        month_update_date(i)=fix(month_date_num(i)/10000)*10000+630;
    else%������ϰ��꣬����ȥ��12/31������
        month_update_date(i)=fix(month_date_num(i)/10000-1)*10000+1231;
    end
end
%������Ӧ�ö�Ӧ�ڼ���������
month_update_pointer=zeros(1,length(month_date_num));
for(i=1:length(month_date_num))
    for(j=1:length(update_date_num))
        if(update_date_num(j)==month_update_date(i))
            month_update_pointer(i)=j;
            break;
        end
    end
end
%���Ƹ����յĳɷֹ���չ���¶�
for(i=1:length(month_update_pointer))
    if(month_update_pointer(i)~=0)
        month_element(:,i)=element_stock(:,month_update_pointer(i));
    end
end
%% 2.����ÿ��month_date�µ���Ч�ɷݸ���:month_element_num
[m,n]=size(month_element);
for(i=1:n)%��������month_date
    month_element_num(i)=0;
    for(j=1:m)%�������гɷֹ�
        if(isempty(cell2mat(month_element(j,i)))==0)%������ǿգ�����Ч����Ч����1
             month_element_num(i)= month_element_num(i)+1;
        end
    end
end
%% 3.���ݳɷֹɴ�wind������PE���ݣ�ttm��
total_data=[];
for(i=1:n)%����ÿ��month_date
    
    if(month_element_num(i)>0)%��������гɷ�
        %���ȹ�����һ�����������ɷֹ�str���У��确000001.SZ,000002,SZ,...��
        stock_cell={};
        stock_str=[];
        stock_cell=month_element(1:month_element_num(i),i);
        stock_str=cell2mat(stock_cell(1));
        for(j=2:length(stock_cell))
            stock_str=[stock_str,',',cell2mat(stock_cell(j))];
        end
        %������������������month_date_num�ַ�����ʽ����'20190228'
        stock_date=num2str(month_date_num(i));
        %���Ŵ�wind��ȡ���ݣ�wss
        data=w.wss(stock_str,'pe_ttm',['tradeDate=',stock_date]);
        if(length(data)<m)%����ע��ά�����⣬������ָ֤���ɷ������̶�������Ҫ����NaNֱ�����ɷ���
            data=[data;zeros(m-length(data),1)*NaN];
        end
    else%��������޳ɷݸ���
        data=zeros(m,1)*NaN;
    end
    total_data=[total_data,data];
end
PE_data=total_data;
PE_date=month_date';
end