%% 遗传算法优化投资组合实例
%《量化投资：数据挖掘技术与实践》第12章配套程序，电子工业出版社，卓金武等编著，70263215@qq.com
%% 导入数据及参数初始化
clc, clear all, close all
load('FTSESTocks')         
% 参数设置
nstocks = 20; % 投资的股票数量
R = R(1:nstocks);
currprice = currprice(1:nstocks);
names = names(1:nstocks);
toSpend = 8000;  %总共投资金额

%% 定义优化问题
fprofit = @(w) (R-1)'*(currprice.*w(:));    % w(:) 保证列向量
fobj = @(w) -fprofit(w);    % 目标是收益最大化

minSingle = 0;              % 每支股票的最小投资比例
maxSingle = 0.2;            % 每支股票的最大投资比例
lb = minSingle*ones(nstocks,1);             % 每支股票最小投资金额
ub = floor(maxSingle*toSpend./currprice);   % 每支股票最大投资金额

%% 用遗传算法优化
[wOpt,~,flag] = ga(fobj,nstocks,...
    currprice',toSpend,[],[],lb,ub,[],...  % 约束条件
    1:nstocks,...                         
    gaoptimset('EliteCount',20,'PopulationSize',200));  % 优化选项

%% 显示优化结果
wOpt = wOpt';
figure
pie(wOpt/sum(wOpt),names);
title('股票组合投资的配比优化结果')
%% 量化投资：数据挖掘技术与实践
