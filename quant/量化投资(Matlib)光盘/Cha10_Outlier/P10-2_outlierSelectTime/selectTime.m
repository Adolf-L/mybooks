%% 基于异常检测技术的量化择时实例
%《量化投资：数据挖掘技术与实践》第10章配套程序，电子工业出版社，卓金武等编著，70263215@qq.com 
clc, clear all, close all
%% 导入数据
V = xlsread('sz000001.xls','Sheet1','F1:F758');
C = xlsread('sz000001.xls','Sheet1','E1:E758');

%% 可视化原始数据
N = size(V,1);
T = (1:N)';
plot(T, V, 'ro');
xlabel('记录编号','fontsize',12);
ylabel('成交量', 'fontsize',12);
set(gca,'linewidth',2);
%% 预计预处理：删除成交量为0的数据
id = V > 0;
V1 = V(id);
C1 = C(id);
%% 通过平滑法寻找基线
N1 = size(V1,1);
T1 = (1:N1)';
y1 = smooth(V1,20);
figure
subplot(2,1,1)
plot(T1, V1, 'ro',  T1, y1);
xlabel('记录编号','fontsize',12);
ylabel('成交量', 'fontsize',12);
set(gca,'linewidth',2);

%% 判断离群点
a = std(V1);
y2 = y1 + 1.5*a;
ou_id = V1>y2;
ou = V1(ou_id);
hold on
plot(T1, y2, ':r')
hold on
plot(T1(ou_id), ou, 'k*')
subplot(2,1,2)
plot(T1, C1)
xlabel('记录编号','fontsize',12);
ylabel('成交量', 'fontsize',12);
set(gca,'linewidth',2);



