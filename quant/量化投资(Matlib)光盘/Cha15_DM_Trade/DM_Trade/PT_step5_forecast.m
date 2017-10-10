%% 基于数据挖掘技术的程序化选股step5: 训练神经网络并进行模型评估
%《量化投资：数据挖掘技术与实践》第15章配套程序，电子工业出版社，卓金武等编著，70263215@qq.com 
%% % 读入数据
clc, clear all, close all
stdata=xlsread('selected_tdata.xlsx');
sfdata=xlsread('selected_fdata.xlsx');
[rn, cn]=size(stdata);
P_X=stdata(:,2:(cn-1));
P_Y=stdata(:,cn);
P1_X=sfdata(:,2:(cn-1));
% 数据转置
p_net=P_X';
t_net=P_Y';
p1_net=P1_X';

%BP网络训练
net = feedforwardnet(20);
net=train(net,p_net,t_net)    %开始训练，其中p_net,t_net分别为输入输出样本

%股票增长概率预测
r_net = sim(net,p1_net);
r_net=r_net';
% [row_n1, column_m1]=size(r_net);
% 将数据保存到excel
% 将数据保存到excel
fr_data=[sfdata, r_net];
fr_cn = size(fr_data,2);
frs_data = sortrows(fr_data, -fr_cn);
xlswrite('forecast_result.xlsx', frs_data);

%% 模型正确率的评估
r_nn = sim(net,p_net);
Y_nn = round(r_nn);
c_id=Y_nn==t_net;
stn=size(t_net,2);
ctn=sum(c_id);
co_rate=ctn/stn;
disp(['全部训练的正确率为:' num2str(co_rate)]);
er_rate=1-co_rate;
mrate=[co_rate, er_rate];
figure
pie(mrate)
title('模型的正确率和错误率')

%% 说明： 模型评估采用全集验证
