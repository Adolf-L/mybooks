%% 股票聚类
%《量化投资：数据挖掘技术与实践》第8章配套程序，电子工业出版社，卓金武等编著，70263215@qq.com 
%% 读取数据
clc, clear all, close all
X0 = xlsread('StockFinance.xlsx','Sheet1','E2:N4735');

%% 数据归一化
[rn,cn]=size(X0);
X=zeros(rn,cn);
  for k=1:cn
      %基于均值方差的离群点数据归一化
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

%% 层次聚类
numClust = 3;
dist_h = 'spearman';
link = 'weighted';
hidx = clusterdata(X, 'maxclust', numClust, 'distance' , dist_h, 'linkage', link);

%绘制聚类效果图
figure
F2 = plot3(X(hidx==1,1), X(hidx==1,2),X(hidx==1,3),'r*', ...
           X(hidx==2,1), X(hidx==2,2),X(hidx==2,3), 'bo', ...
           X(hidx==3,1), X(hidx==3,2),X(hidx==3,3), 'kd');
set(gca,'linewidth',2);
grid on
set(F2,'linewidth',2, 'MarkerSize',8);
set(gca,'linewidth',2);
xlabel('每股收益','fontsize',12);
ylabel('每股净资产','fontsize',12);
zlabel('净资产收益率','fontsize',12);
title('层次聚类方法聚类结果')

% 评估各类别的相关程度
dist_metric_h = pdist(X,dist_h);
dd_h = squareform(dist_metric_h);
[~,idx] = sort(hidx);
dd_h = dd_h(idx,idx);
figure
imagesc(dd_h)
set(gca,'linewidth',2);
xlabel('数据点', 'fontsize',12)
ylabel('数据点', 'fontsize',12)
title('层次聚类结果相关程度图')
ylabel(colorbar,['距离矩阵:', dist_h])
axis square

% 计算同型相关系数
Z = linkage(dist_metric_h,link);
cpcc = cophenet(Z,dist_metric_h);
disp('同表象相关系数: ')
disp(cpcc)

% 层次结构图
set(0,'RecursionLimit',5000)
figure
dendrogram(Z)
set(gca,'linewidth',2);
set(0,'RecursionLimit',500)
xlabel('数据点', 'fontsize',12)
ylabel ('距离', 'fontsize',12)
title(['CPCC: ' sprintf('%0.4f',cpcc)])
%% 股票聚类程序