function [quantile_data,quantile_date,quantile_name]=get_quantile(EP_data,EP_date)
%% 输入EP数据（一列代表一个时间），返回分位点数据（一行代表一个时间）
[m,n]=size(EP_data);
%% 1.统计每个时间截面有效data数
EP_data_num=zeros(1,n);
for(i=1:n)
    for(j=1:m)
        if(isnan(EP_data(j,i))==0)
            EP_data_num(i)=EP_data_num(i)+1;
        end
    end
end
%% 2.对EP数据每列排序,NaN数据往后靠(其实没有必要做这一步，但是可以检查程序漏洞)
EP_data_rank=EP_data*NaN;
for(i=1:n)
    tools=sortrows(EP_data(:,i),-1);
    tools(1:(m-EP_data_num(i)))=[];
    EP_data_rank(1:length(tools),i)=tools;
end
%% 3.输入一列data，取得分位数:prctile(EP_data,0~100)
cut=[0:5:100];
for(i=1:length(cut))
    quantile_data(:,i)=(prctile(EP_data,cut(i)))';%每一个纵列为一种分位点，每行为一时间
end
quantile_date=EP_date';
for(i=1:length(cut))
    quantile_name(i)=cellstr([num2str(cut(i)),'%EP分位数']);
end
end