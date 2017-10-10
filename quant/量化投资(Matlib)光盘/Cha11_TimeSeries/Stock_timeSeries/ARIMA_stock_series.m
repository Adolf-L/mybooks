%% ����ʱ�����еĹ�Ʊ�۸�Ԥ��
%������Ͷ�ʣ������ھ�����ʵ������11�����׳��򣬵��ӹ�ҵ�����磬׿����ȱ�����70263215@qq.com 
%% ��ȡ��Ʊ����
clc, clear all, close all
Y=xlsread('sdata','Sheet1','E1:E227');
N = length(Y);

%% ԭʼ���ݿ��ӻ�
figure(1)
plot(Y); xlim([1,N])
set(gca,'XTick',[1:18:N])
title('ԭʼ��Ʊ�۸�')
ylabel('Ԫ')

%% ARIMAģ��
 model = arima('Constant',0,'D',1,'Seasonality',12,...
              'MALags',1,'SMALags',12)
Y0 = Y(1:13);
[fit,VarCov] = estimate(model,Y(14:end),'Y0',Y0);

%% ����Ԥ��Ч��
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

%% Ԥ��δ����Ʊ����.
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
title('95%��������')
legend([h1,h2],'Forecast','95% Interval','Location','NorthWest')
hold off
