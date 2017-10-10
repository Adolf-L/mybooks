%% 配对交易
%《量化投资：数据挖掘技术与实践》第14章配套程序，电子工业出版社，卓金武等编著，70263215@qq.com
%% 加载数据
clc, clear all, close all
load oilData
LCO = double(brent);
WTI = double(light);
clearvars -except LCO WTI
pairsChart(LCO, WTI)
% Let's focus on the last 11 days' of data:
series = [LCO(end-4619 : end, 4) WTI(end-4619 : end, 4)];

%% 协整检查
egcitest(series)
%检查更小的时间范围
[h, ~, ~, ~, reg1] = egcitest(series(1700:2000, :));
display(h)
display(reg1)
%% 测试策略
pairs(series, 420, 60)

%% 扫描最佳组合
window = 120:60:420;
freq   = 10:10:60;
range = {window, freq};

annualScaling = sqrt(250*7*60);
cost = 0.01;

pfun = @(x) pairsFun(x, series, annualScaling, cost);

tic
[~,param] = parameterSweep(pfun,range);
toc

pairs(series, param(1), param(2), 1, annualScaling, cost)
