%% 基于数据挖掘技术的程序化选股step4: 变量筛选
%《量化投资：数据挖掘技术与实践》第15章配套程序，电子工业出版社，卓金武等编著，70263215@qq.com 
%% 读取变量信息
clc, clear all, close all
tdata=xlsread('train_sample');
fdata=xlsread('forecast_sample');
[rn, cn]=size(tdata);
A=tdata(:, 2:cn);

%% 计算并显示相关系数矩阵
covmat = corrcoef(A);
varargin = {'x1','x2','x3','x4','x5','x6','x7','x8','x9','x10',...
    'x11','x12','x13','x14','x15','x16','x17','x18','x19','x20', 'y'};
figure;
x = size(covmat, 2);
imagesc(covmat);
set(gca,'XTick',1:x);
set(gca,'YTick',1:x);
% if nargin > 1
    set(gca,'XTickLabel',varargin);
    set(gca,'YTickLabel',varargin);
% end
axis([0 x+1 0 x+1]);
grid;
colorbar;
%% 选择相关性较强的变量
covth = 0.2;
c1 = covmat(cn-1, 1:(cn-2));
vid = abs(c1)>covth;
idc=1:cn;
A1=A(:,1:(cn-2));
A2=A1(:,vid);
stdata = [ tdata(:,1),A2, tdata(:,cn)];
B = fdata(:,2:(cn-1));
B1= B(:,vid);
sfdata = [fdata(:,1), B1];
xlswrite('selected_tdata.xlsx', stdata);
xlswrite('selected_fdata.xlsx', sfdata);
%% 说明：变量筛选依据为变量相关性
