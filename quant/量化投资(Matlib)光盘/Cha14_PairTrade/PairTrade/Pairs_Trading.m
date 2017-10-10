%% ��Խ���
%������Ͷ�ʣ������ھ�����ʵ������14�����׳��򣬵��ӹ�ҵ�����磬׿����ȱ�����70263215@qq.com
%% ��������
clc, clear all, close all
load oilData
LCO = double(brent);
WTI = double(light);
clearvars -except LCO WTI
pairsChart(LCO, WTI)
% Let's focus on the last 11 days' of data:
series = [LCO(end-4619 : end, 4) WTI(end-4619 : end, 4)];

%% Э�����
egcitest(series)
%����С��ʱ�䷶Χ
[h, ~, ~, ~, reg1] = egcitest(series(1700:2000, :));
display(h)
display(reg1)
%% ���Բ���
pairs(series, 420, 60)

%% ɨ��������
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
