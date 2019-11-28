clear all;clc

%% �����趨
%������Ҫ�����ʱ�����еĿ�ʼʱ�������ʱ�䣺
%��˹���ָ������ʼ���ڣ�1971-01-31
start_date='1971-01-31'
%����˹��ҵָ������ʼ���ڣ�1899-12-31
%start_date='1899-12-31'
%����500ָ������ʼ���ڣ�1928-01-31
%start_date='1928-01-31'

end_date='2019-10-31'
target_sector='IXIC.GI'
%target_sector='DJI.GI'
%target_sector='SPX.GI'
%%
% ����month_date,������Ҫ�����ʱ������
month_date=get_output_series(start_date,end_date);
% ��month_date���Ƴ�update_date,����Ҫ���³ɷݵ���������
update_date=get_update_date(month_date);
%��ȡ�ɷֹ�
[element_stock,element_time]=get_sector_element(target_sector,update_date);
%��ȡPE
[PE_data,PE_date]=get_pe_ttm(element_stock,update_date,month_date);
%��ȡPB
[PB_data,PB_date]=get_pb_ttm(element_stock,update_date,month_date);
%��ȡPS
[PS_data,PS_date]=get_ps_ttm(element_stock,update_date,month_date);
%��ȡPCF
[PCF_data,PCF_date]=get_pcf_ttm(element_stock,update_date,month_date);
%PEתEP
[EP_data,EP_date]=getEP(PE_data,PE_date);
%PBתBP
[BP_data,BP_date]=getEP(PB_data,PB_date);
%PSתSP
[SP_data,SP_date]=getEP(PS_data,PS_date);
%PCFתCFP
[CFP_data,CFP_date]=getEP(PCF_data,PCF_date);
%��ȡ��λ��
[quantile_data_PE,quantile_date_PE,quantile_name_PE]=get_quantile(EP_data,EP_date);
[quantile_data_PB,quantile_date_PB,quantile_name_PB]=get_quantile(BP_data,BP_date);
[quantile_data_PS,quantile_date_PS,quantile_name_PS]=get_quantile(SP_data,SP_date);
[quantile_data_PCF,quantile_date_PCF,quantile_name_PCF]=get_quantile(CFP_data,CFP_date);
%չʾ����
output_matrix1=[cellstr('ʱ��') quantile_name_PE;[quantile_date_PE' num2cell(quantile_data_PE)]];
output_matrix2=[cellstr('ʱ��') quantile_name_PB;[quantile_date_PB' num2cell(quantile_data_PB)]];
output_matrix3=[cellstr('ʱ��') quantile_name_PS;[quantile_date_PS' num2cell(quantile_data_PS)]];
output_matrix4=[cellstr('ʱ��') quantile_name_PCF;[quantile_date_PCF' num2cell(quantile_data_PCF)]]