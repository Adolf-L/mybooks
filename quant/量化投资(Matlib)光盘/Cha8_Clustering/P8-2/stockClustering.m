%% ��Ʊ����
%������Ͷ�ʣ������ھ�����ʵ������8�����׳��򣬵��ӹ�ҵ�����磬׿����ȱ�����70263215@qq.com 
%% ��ȡ����
clc, clear all, close all
X0 = xlsread('StockFinance.xlsx','Sheet1','E2:N4735');

%% ���ݹ�һ��
[rn,cn]=size(X0);
X=zeros(rn,cn);
  for k=1:cn
      %���ھ�ֵ�������Ⱥ�����ݹ�һ��
      xm=mean(X0(:,k));
      xs=std(X0(:,k));
      for j=1:rn 
            if X0(j,k)>xm+2*xs
            X(j,k)=1;
            elseif X0(j,k)<xm-2*xs
            X(j,k)=0;
            else
            X(j,k)=(X0(j,k)-(xm-2*xs))/(4*xs);
            end
      end
  end
xlswrite('norm_data.xlsx', X);

%% ��ξ���
numClust = 3;
dist_h = 'spearman';
link = 'weighted';
hidx = clusterdata(X, 'maxclust', numClust, 'distance' , dist_h, 'linkage', link);

%���ƾ���Ч��ͼ
figure
F2 = plot3(X(hidx==1,1), X(hidx==1,2),X(hidx==1,3),'r*', ...
           X(hidx==2,1), X(hidx==2,2),X(hidx==2,3), 'bo', ...
           X(hidx==3,1), X(hidx==3,2),X(hidx==3,3), 'kd');
set(gca,'linewidth',2);
grid on
set(F2,'linewidth',2, 'MarkerSize',8);
set(gca,'linewidth',2);
xlabel('ÿ������','fontsize',12);
ylabel('ÿ�ɾ��ʲ�','fontsize',12);
zlabel('���ʲ�������','fontsize',12);
title('��ξ��෽��������')

% ������������س̶�
dist_metric_h = pdist(X,dist_h);
dd_h = squareform(dist_metric_h);
[~,idx] = sort(hidx);
dd_h = dd_h(idx,idx);
figure
imagesc(dd_h)
set(gca,'linewidth',2);
xlabel('���ݵ�', 'fontsize',12)
ylabel('���ݵ�', 'fontsize',12)
title('��ξ�������س̶�ͼ')
ylabel(colorbar,['�������:', dist_h])
axis square

% ����ͬ�����ϵ��
Z = linkage(dist_metric_h,link);
cpcc = cophenet(Z,dist_metric_h);
disp('ͬ�������ϵ��: ')
disp(cpcc)

% ��νṹͼ
set(0,'RecursionLimit',5000)
figure
dendrogram(Z)
set(gca,'linewidth',2);
set(0,'RecursionLimit',500)
xlabel('���ݵ�', 'fontsize',12)
ylabel ('����', 'fontsize',12)
title(['CPCC: ' sprintf('%0.4f',cpcc)])
%% ��Ʊ�������