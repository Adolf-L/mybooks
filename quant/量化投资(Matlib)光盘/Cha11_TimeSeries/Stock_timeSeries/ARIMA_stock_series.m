%% 基于时间序列的股票价格预测
%《量化投资：数据挖掘技术与实践》第11章配套程序，电子工业出版社，卓金武等编著，70263215@qq.com 
%% 读取股票数据
clc, clear all, close all
Y=xlsread('sdata','Sheet1','E1:E227');
N = length(Y);

%% 原始数据可视化
figure(1)
plot(Y); xlim([1,N])
set(gca,'XTick',[1:18:N])
title('原始股票价格')
ylabel('元')

%% ARIMA模型
 model = arima('Constant',0,'D',1,'Seasonality',12,...
              'MALags',1,'SMALags',12)
Y0 = Y(1:13);
[fit,VarCov] = estimate(model,Y(14:end),'Y0',Y0);

%% 评估预测效果
Y1 = Y(1:100);
Y2 = Y(101:end);

Yf1 = forecast(fit,100,'Y0',Y1);

figure(2)
plot(1:N,Y,'b','LineWidth',2)

hold on
plot(101:200,Yf1,'k--','LineWidth',1.5)
xlim([0,200])
title('Prediction Error')
legend('Observed','Forecast','Location','NorthWest')
hold off

%% 预测未来股票趋势.
[Yf,YMSE] = forecast(fit,60,'Y0',Y);
upper = Yf + 1.96*sqrt(YMSE);
lower = Yf - 1.96*sqrt(YMSE);

figure(3)
plot(Y,'b')
hold on
h1 = plot(N+1:N+60,Yf,'r','LineWidth',2);
h2 = plot(N+1:N+60,upper,'k--','LineWidth',1.5);
plot(N+1:N+60,lower,'k--','LineWidth',1.5)
xlim([0,N+60])
title('95%置信区间')
legend([h1,h2],'Forecast','95% Interval','Location','NorthWest')
hold off
