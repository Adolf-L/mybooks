%% ����Ӧ��ʵ��������ѡ�ɷ�
%������Ͷ�ʣ������ھ�����ʵ������4�����׳��򣬵��ӹ�ҵ�����磬׿����ȱ�����70263215@qq.com 
%% ��������
clc, clear all, close all
stdata=xlsread('selected_tdata.xlsx');
sfdata=xlsread('selected_fdata.xlsx');
[rn, cn]=size(stdata);
X=stdata(:,2:(cn-1));
Y=stdata(:,cn);
X_f=sfdata(:,2:(cn-1));
%% ���ý�����֤��ʽ�����ѡ��50%��������Ϊ��������
cv = cvpartition(size(X,1),'holdout',0.50);
% ѵ����
Xtrain = X(training(cv),:);
Ytrain = Y(training(cv),:);
% ���Լ���
Xtest = X(test(cv),:);
Ytest = Y(test(cv),:);

%% ���þ�����ѵ��������������
% ѵ��������
t = ClassificationTree.fit(Xtrain,Ytrain);
view(t,'Mode','graph')
% ����Ԥ��
Y_t = t.predict(Xtest);
% �����������
disp('������������������')
C = confusionmat(Ytest,Y_t)
disp(['ȫ��ѵ������ȷ��Ϊ:' num2str((C(1,1)+C(2,2))/sum(sum(C)))]);

%% ������������Ԥ��
Y_f = t.predict(X_f);
xlswrite('selected_fdata.xlsx', Y_f, 'sheet1',['J1:J' num2str(size(Y_f,1))]);
%% ˵������������þ������㷨���з��ࡣ