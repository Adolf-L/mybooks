%% �Ŵ��㷨�Ż�Ͷ�����ʵ��
%������Ͷ�ʣ������ھ�����ʵ������12�����׳��򣬵��ӹ�ҵ�����磬׿����ȱ�����70263215@qq.com
%% �������ݼ�������ʼ��
clc, clear all, close all
load('FTSESTocks')         
% ��������
nstocks = 20; % Ͷ�ʵĹ�Ʊ����
R = R(1:nstocks);
currprice = currprice(1:nstocks);
names = names(1:nstocks);
toSpend = 8000;  %�ܹ�Ͷ�ʽ��

%% �����Ż�����
fprofit = @(w) (R-1)'*(currprice.*w(:));    % w(:) ��֤������
fobj = @(w) -fprofit(w);    % Ŀ�����������

minSingle = 0;              % ÿ֧��Ʊ����СͶ�ʱ���
maxSingle = 0.2;            % ÿ֧��Ʊ�����Ͷ�ʱ���
lb = minSingle*ones(nstocks,1);             % ÿ֧��Ʊ��СͶ�ʽ��
ub = floor(maxSingle*toSpend./currprice);   % ÿ֧��Ʊ���Ͷ�ʽ��

%% ���Ŵ��㷨�Ż�
[wOpt,~,flag] = ga(fobj,nstocks,...
    currprice',toSpend,[],[],lb,ub,[],...  % Լ������
    1:nstocks,...                         
    gaoptimset('EliteCount',20,'PopulationSize',200));  % �Ż�ѡ��

%% ��ʾ�Ż����
wOpt = wOpt';
figure
pie(wOpt/sum(wOpt),names);
title('��Ʊ���Ͷ�ʵ�����Ż����')
%% ����Ͷ�ʣ������ھ�����ʵ��
