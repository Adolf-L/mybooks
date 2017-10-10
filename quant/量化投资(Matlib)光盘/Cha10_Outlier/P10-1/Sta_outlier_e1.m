%% 基于统计方法的离群点诊断实例
%《量化投资：数据挖掘技术与实践》第10章配套程序，电子工业出版社，卓金武等编著，70263215@qq.com 
%% 数据准备
clc, clear all, close all
x = [6,7,6,8,9,10,8,11,7,9,12,7,11,8,13,7,8,14,9,12];
u = mean(x);
a = std(x);
tolerance = 2;
bound = tolerance * a;
N = size(x,2);
Id = 1:N;
Upper_Bound = (u + bound)*ones(1,N);
Lower_Bound = (u - bound)*ones(1,N);
 
%% 绘制上下限
figure;
plot(Id, x, 'bO');
hold on;
plot(Id, Upper_Bound, '-r','linewidth',2);
hold on
plot(Id, Lower_Bound,'-r','linewidth',2);
hold on
plot(Id, u*ones(1,N),'--k','linewidth',2);
xlabel('编号','fontsize', 12);
ylabel('年龄', 'fontsize',12)
set(gca, 'linewidth',2)
title('基于统计方法的离群点诊断','fontsize',12)

%% 识别并显示离群点
Outlier_id1 = x < (u - bound); 
Outlier_id2 = x > (u + bound);
Outlier_id = Outlier_id1 | Outlier_id2;
hold on
plot(Id(Outlier_id), x(Outlier_id), 'r*','linewidth',2);
disp(['离群点为：',num2str(x(Outlier_id))])


