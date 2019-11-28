clear all;clc

%% 参数设定
%我们想要输出的时间序列的开始时间与结束时间：
%纳斯达克指数的起始日期：1971-01-31
start_date='1971-01-31'
%道琼斯工业指数的起始日期：1899-12-31
%start_date='1899-12-31'
%标普500指数的起始日期：1928-01-31
%start_date='1928-01-31'

end_date='2019-10-31'
target_sector='IXIC.GI'
%target_sector='DJI.GI'
%target_sector='SPX.GI'
%%
% 生成month_date,即我们要输出的时间序列
month_date=get_output_series(start_date,end_date);
% 由month_date反推出update_date,即需要更新成份的日期序列
update_date=get_update_date(month_date);
%获取成分股
[element_stock,element_time]=get_sector_element(target_sector,update_date);
%获取PE
[PE_data,PE_date]=get_pe_ttm(element_stock,update_date,month_date);
%获取PB
[PB_data,PB_date]=get_pb_ttm(element_stock,update_date,month_date);
%获取PS
[PS_data,PS_date]=get_ps_ttm(element_stock,update_date,month_date);
%获取PCF
[PCF_data,PCF_date]=get_pcf_ttm(element_stock,update_date,month_date);
%PE转EP
[EP_data,EP_date]=getEP(PE_data,PE_date);
%PB转BP
[BP_data,BP_date]=getEP(PB_data,PB_date);
%PS转SP
[SP_data,SP_date]=getEP(PS_data,PS_date);
%PCF转CFP
[CFP_data,CFP_date]=getEP(PCF_data,PCF_date);
%获取分位数
[quantile_data_PE,quantile_date_PE,quantile_name_PE]=get_quantile(EP_data,EP_date);
[quantile_data_PB,quantile_date_PB,quantile_name_PB]=get_quantile(BP_data,BP_date);
[quantile_data_PS,quantile_date_PS,quantile_name_PS]=get_quantile(SP_data,SP_date);
[quantile_data_PCF,quantile_date_PCF,quantile_name_PCF]=get_quantile(CFP_data,CFP_date);
%展示矩阵
output_matrix1=[cellstr('时间') quantile_name_PE;[quantile_date_PE' num2cell(quantile_data_PE)]];
output_matrix2=[cellstr('时间') quantile_name_PB;[quantile_date_PB' num2cell(quantile_data_PB)]];
output_matrix3=[cellstr('时间') quantile_name_PS;[quantile_date_PS' num2cell(quantile_data_PS)]];
output_matrix4=[cellstr('时间') quantile_name_PCF;[quantile_date_PCF' num2cell(quantile_data_PCF)]]