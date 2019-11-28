# -*- coding: utf-8 -*-
import numpy as np
import pandas as pd
from statsmodels.tsa.stattools import adfuller, grangercausalitytests
import xlwt
import matplotlib.pyplot as plt
import seaborn as sns
indexlist = ['EP', 'BP', 'SP', 'CFP']
codelist = ['000300', '000905', '000016']
stagelist = ['主动去库存','被动去库存','主动补库存','被动补库存']

class Para:
    stage = stagelist[2]
    path_data = '.\\input\\'
    path_results = '.\\output\\'
para = Para()
f = open (para.path_results+'result','w')

for j in codelist:
    for i in indexlist:
        file_name = para.path_data + str(i) + '.csv'
        datas_filename = para.path_data + '%s' % j + '_' + '%s' % i + '.xlsx'
        datas = pd.read_excel(datas_filename, index_col=0, parse_dates=True)
        #step 1: 找到个阶段各指标时间序列上相关性最大和最小对应的情况，画出热力图
        datas_minus_signal = datas.iloc[:,2:]
        corr=datas_minus_signal.corr().iloc[:1,:].T
        corr_final=corr.iloc[1:,:]
        corr_final.to_excel(para.path_results+'%s' % j + '_' + '%s' % i + '_corr.xlsx')
        corr_max=corr_final.iloc[:,-1].max()
        corr_min=corr_final.iloc[:,-1].min()
        corr_argmax = corr_final[corr_final.iloc[:,-1] == corr_final.iloc[:,-1].max()].index
        corr_argmin = corr_final[corr_final.iloc[:, -1] == corr_final.iloc[:, -1].min()].index
        print('%s'%j +':%s'% i+':时间序列上相关性最大的是'+corr_argmax,"%.4f" % corr_max,file = f)
        print('%s'%j +':%s'% i+':时间序列上相关性最小的是'+corr_argmin,"%.4f" % corr_min,file = f)
        
        #step 2: ADF检验
        for m in range(0,datas_minus_signal.columns.size-1):
            print('%s'%j +': %s'% i, m,file = f)
            print(adfuller(datas_minus_signal.iloc[:,m+1]),file = f)
            

for j in codelist:
    for i in indexlist:
        file_name = para.path_data + str(i) + '.csv'
        datas_filename = para.path_data + '%s' % j + '_' + '%s' % i + '.xlsx'
        datas = pd.read_excel(datas_filename, index_col=0, parse_dates=True)

        #step 3：格兰杰因果检验
        y = datas.iloc[:,2]
        for x in range(0,datas.columns.size-1):
            X = datas.iloc[:, x]
            df = pd.merge(y, X, left_index=True, right_index=True)
            print('%s'%j +':%s'% i,x)
            grangercausalitytests(df,maxlag=36)

        #step 4：输出excel
        # 代码优化：创建一个excel
        # output_filename = '%s' % j +'_'+ '%s' % i + Para.stage +'.xlsx'
        # work_book=xlwt.Workbook(encoding='utf-8')
        outputname = para.path_results + '%s' % j + '_' + '%s' % i + '分位点_' + para.stage +'.xlsx'
        with pd.ExcelWriter(outputname) as writer:
            for x in range(3, datas.shape[1]):
                if Para.stage == '主动去库存':
                    # signal=1为主动去库存
                    y = pd.DataFrame(datas[datas.signal == 1].iloc[:, 2])
                    X = pd.DataFrame(datas[datas.signal == 1].iloc[:, x])
                elif Para.stage == '被动去库存':
                    y = pd.DataFrame(datas[datas.signal == 2].iloc[:,2])
                    X = pd.DataFrame(datas[datas.signal == 2].iloc[:, x])
                elif Para.stage == '主动补库存':
                    y = pd.DataFrame(datas[datas.signal == 3].iloc[:,2])
                    X = pd.DataFrame(datas[datas.signal == 3].iloc[:, x])
                else:
                    y = pd.DataFrame(datas[datas.signal == 4].iloc[:,2])
                    X = pd.DataFrame(datas[datas.signal == 4].iloc[:, x])
                df = pd.merge(y, X, left_index=True, right_index=True)
                print(para.stage,'%s' % j + ':%s' % i + ':',x , '%',df.corr().iloc[1,0])
                a = (x - 3) * 5
                X_name = 'percentile' + '%s' % a + '%'
                df.columns = ['close price', str(X_name)]
                df.index = range(df.shape[0])
                sheetname =  '%s' % j + '_' + '%s' % a + '%' + para.stage
                #需要生成文件的话，取消下行的注释
                #df.to_excel(writer, sheet_name=sheetname)
