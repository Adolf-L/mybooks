%% �����쳣��⼼����������ʱʵ��
%������Ͷ�ʣ������ھ�����ʵ������10�����׳��򣬵��ӹ�ҵ�����磬׿����ȱ�����70263215@qq.com 
clc, clear all, close all
%% ��������
V = xlsread('sz000001.xls','Sheet1','F1:F758');
C = xlsread('sz000001.xls','Sheet1','E1:E758');

%% ���ӻ�ԭʼ����
N = size(V,1);
T = (1:N)';
plot(T, V, 'ro');
xlabel('��¼���','fontsize',12);
ylabel('�ɽ���', 'fontsize',12);
set(gca,'linewidth',2);
%% Ԥ��Ԥ����ɾ���ɽ���Ϊ0������
id = V > 0;
V1 = V(id);
C1 = C(id);
%% ͨ��ƽ����Ѱ�һ���
N1 = size(V1,1);
T1 = (1:N1)';
y1 = smooth(V1,20);
figure
subplot(2,1,1)
plot(T1, V1, 'ro',  T1, y1);
xlabel('��¼���','fontsize',12);
ylabel('�ɽ���', 'fontsize',12);
set(gca,'linewidth',2);

%% �ж���Ⱥ��
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
xlabel('��¼���','fontsize',12);
ylabel('�ɽ���', 'fontsize',12);
set(gca,'linewidth',2);



