function [quantile_data,quantile_date,quantile_name]=get_quantile(EP_data,EP_date)
%% ����EP���ݣ�һ�д���һ��ʱ�䣩�����ط�λ�����ݣ�һ�д���һ��ʱ�䣩
[m,n]=size(EP_data);
%% 1.ͳ��ÿ��ʱ�������Чdata��
EP_data_num=zeros(1,n);
for(i=1:n)
    for(j=1:m)
        if(isnan(EP_data(j,i))==0)
            EP_data_num(i)=EP_data_num(i)+1;
        end
    end
end
%% 2.��EP����ÿ������,NaN��������(��ʵû�б�Ҫ����һ�������ǿ��Լ�����©��)
EP_data_rank=EP_data*NaN;
for(i=1:n)
    tools=sortrows(EP_data(:,i),-1);
    tools(1:(m-EP_data_num(i)))=[];
    EP_data_rank(1:length(tools),i)=tools;
end
%% 3.����һ��data��ȡ�÷�λ��:prctile(EP_data,0~100)
cut=[0:5:100];
for(i=1:length(cut))
    quantile_data(:,i)=(prctile(EP_data,cut(i)))';%ÿһ������Ϊһ�ַ�λ�㣬ÿ��Ϊһʱ��
end
quantile_date=EP_date';
for(i=1:length(cut))
    quantile_name(i)=cellstr([num2str(cut(i)),'%EP��λ��']);
end
end