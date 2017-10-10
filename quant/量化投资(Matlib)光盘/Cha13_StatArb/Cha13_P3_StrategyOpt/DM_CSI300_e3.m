%% 多信号组合优化
%《量化投资：数据挖掘技术与实践》第13章配套程序，电子工业出版社，卓金武等编著，70263215@qq.com
clc, clear all, close all
%% 加载数据
load CSI300.mat
CSI300_1Mn = raw_CSI300_1Mn(:, 4);
CSI300_1Mn = CSI300_1Mn(1:end);
CSI300_EOD = raw_CSI300_EOD(:, 4);
testPts = floor(0.8*length(raw_CSI300_1Mn(:,4)));
step = 5; % 30 minute interval
CSI = raw_CSI300_1Mn(1:step:testPts,2:4);
CSIV = raw_CSI300_1Mn(testPts+1:step:end,2:4);
annualScaling = sqrt(250*60*4/step);
cost = 0.01;
addpath('gaFiles')

%% Williams %R
w = willpctr(CSI,50);
plot(w)

%% Williams %R trading strategy
% Generate a trading signal each time we cross the -50% mark (up is a buy,
% down is a sell).
wpr(CSI,100,annualScaling,cost)

%% WPR performance
range = {1:50};
wfun = @(x) wprFun(x,CSI,annualScaling,cost);
tic
[maxSharpe,param,sh] = parameterSweep(wfun,range);
toc
wpr(CSI,param,annualScaling,cost)
figure
plot(sh)
ylabel('Sharpe''s Ratio')

%% 创建交易信号
N = 1; M = 3; thresh = 60; P = 11; Q = 3;
sma = leadlag(CSI(:,end),N,M,annualScaling,cost);
srs = rsi(CSI(:,end),[P Q],thresh,annualScaling,cost);
swr = wpr(CSI,param,annualScaling,cost);

signals = [sma srs swr];
names = {'MA','RSI','WPR'};
%% 绘制交易信号
figure
ax(1) = subplot(2,1,1); plot(CSI(:,end));
ax(2) = subplot(2,1,2); imagesc(signals')
cmap = colormap([1 0 0; 0 0 1; 0 1 0]);
set(gca,'YTick',1:length(names),'YTickLabel',names);
linkaxes(ax,'x');

%% Generate initial population
% Generate initial population for signals
close all
I = size(signals,2);
pop = initializePopulation(I);
imagesc(pop)
xlabel('Bit Position'); ylabel('Individual in Population')
colormap([1 0 0; 0 1 0]); set(gca,'XTick',1:size(pop,2))
%% Fitness Function
% Objective is to find a target bitstring (minimum value)
type fitness
%%
% Objective function definition
obj = @(pop) fitness(pop,signals,CSI(:,end),annualScaling,cost)
%%
% Evalute objective for population
obj(pop)
%% 遗传算法优化信号组合
options = gaoptimset('Display','iter','PopulationType','bitstring',...
    'PopulationSize',size(pop,1),...
    'InitialPopulation',pop,...
    'CrossoverFcn', @crossover,...
    'MutationFcn', @mutation,...
    'PlotFcns', @plotRules,...
    'Vectorized','on');

[best,minSh] = ga(obj,size(pop,2),[],[],[],[],[],[],[],options)

%% 评估结果
s = tradeSignal(best,signals);
s = (s*2-1); % scale to +/-1
r  = [0; s(1:end-1).*diff(CSI(:,end))-abs(diff(s))*cost/2];
sh = annualScaling*sharpe(r,0);

figure
ax(1) = subplot(2,1,1);
plot(CSI(:,end))
title(['Evolutionary Learning Resutls, Sharpe Ratio = ',num2str(sh,3)])
ax(2) = subplot(2,1,2);
plot([s,cumsum(r)])
legend('Position','Cumulative Return','Location','Best')
title(['Final Return = ',num2str(sum(r),3), ...
    ' (',num2str(sum(r)/CSI(1,end)*100,3),'%)'])
linkaxes(ax,'x');

%%
sma = leadlag(CSIV(:,end),N,M,annualScaling,cost);
srs = rsi(CSIV(:,end),[P Q],thresh,annualScaling,cost);
swr = wpr(CSIV,param,annualScaling,cost);
signals = [sma srs swr];

s = tradeSignal(best,signals);
s = (s*2-1); % scale to +/-1
r  = [0; s(1:end-1).*diff(CSIV(:,end))-abs(diff(s))*cost/2];
sh = annualScaling*sharpe(r,0);

% Plot results
figure
ax(1) = subplot(2,1,1);
plot(CSIV(:,end))
title(['Evolutionary Learning Resutls, Sharpe Ratio = ',num2str(sh,3)])
ax(2) = subplot(2,1,2);
plot([s,cumsum(r)])
legend('Position','Cumulative Return','Location','Best')
title(['Final Return = ',num2str(sum(r),3), ...
    ' (',num2str(sum(r)/CSIV(1,end)*100,3),'%)'])
linkaxes(ax,'x');

