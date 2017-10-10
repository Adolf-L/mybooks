%% 分类应用实例：分类选股法
%《量化投资：数据挖掘技术与实践》第4章配套程序，电子工业出版社，卓金武等编著，70263215@qq.com 
%% 读入数据
clc, clear all, close all
stdata=xlsread('selected_tdata.xlsx');
sfdata=xlsread('selected_fdata.xlsx');
[rn, cn]=size(stdata);
X=stdata(:,2:(cn-1));
Y=stdata(:,cn);
X_f=sfdata(:,2:(cn-1));
%% 设置交叉验证方式：随机选择50%的样本作为测试样本
cv = cvpartition(size(X,1),'holdout',0.50);
% 训练集
Xtrain = X(training(cv),:);
Ytrain = Y(training(cv),:);
% 测试集合
Xtest = X(test(cv),:);
Ytest = Y(test(cv),:);

%% 采用决策树训练并评估分类器
% 训练分类器
t = ClassificationTree.fit(Xtrain,Ytrain);
view(t,'Mode','graph')
% 进行预测
Y_t = t.predict(Xtest);
% 计算混淆矩阵
disp('决策树方法分类结果：')
C = confusionmat(Ytest,Y_t)
disp(['全部训练的正确率为:' num2str((C(1,1)+C(2,2))/sum(sum(C)))]);

%% 对新样本进行预测
Y_f = t.predict(X_f);
xlswrite('selected_fdata.xlsx', Y_f, 'sheet1',['J1:J' num2str(size(Y_f,1))]);
%% 说明：本程序采用决策树算法进行分类。