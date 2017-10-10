%% ����ͳ�Ʒ�������Ⱥ�����ʵ��
%������Ͷ�ʣ������ھ�����ʵ������10�����׳��򣬵��ӹ�ҵ�����磬׿����ȱ�����70263215@qq.com 
%% ����׼��
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
 
%% ����������
figure;
plot(Id, x, 'bO');
hold on;
plot(Id, Upper_Bound, '-r','linewidth',2);
hold on
plot(Id, Lower_Bound,'-r','linewidth',2);
hold on
plot(Id, u*ones(1,N),'--k','linewidth',2);
xlabel('���','fontsize', 12);
ylabel('����', 'fontsize',12)
set(gca, 'linewidth',2)
title('����ͳ�Ʒ�������Ⱥ�����','fontsize',12)

%% ʶ����ʾ��Ⱥ��
Outlier_id1 = x < (u - bound); 
Outlier_id2 = x > (u + bound);
Outlier_id = Outlier_id1 | Outlier_id2;
hold on
plot(Id(Outlier_id), x(Outlier_id), 'r*','linewidth',2);
disp(['��Ⱥ��Ϊ��',num2str(x(Outlier_id))])


