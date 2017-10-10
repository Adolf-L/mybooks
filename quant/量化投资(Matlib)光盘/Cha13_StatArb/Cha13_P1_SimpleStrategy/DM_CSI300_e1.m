%% 沪深300交易策略的挖掘与优化
%《量化投资：数据挖掘技术与实践》第13章配套程序，电子工业出版社，卓金武等编著，70263215@qq.com
%% 1 准备数据
clc, clear all, close all
load CSI300.mat
CSI300_1Mn = raw_CSI300_1Mn(:, 4);
CSI300_1Mn = CSI300_1Mn(1:end);
CSI300_EOD = raw_CSI300_EOD(:, 4);
testPts = floor(0.8*length(CSI300_EOD));
CSIClose = CSI300_EOD(1:testPts);
CSICloseV = CSI300_EOD(testPts+1:end);

%% 开发一个简易的交易信号策略
% 用移动均线方法
[lead,lag]=movavg(CSIClose,20,30,'e');
figure
plot([CSIClose,lead,lag]), grid on
legend('Close','Lead','Lag','Location','Best')

% 建议交易信号和策略表现评估方式，这里假设全年有250个交易日
s = zeros(size(CSIClose));
s(lead>lag) = 1;                         % Buy  (long)
s(lead<lag) = -1;                        % Sell (short)
r  = [0; s(1:end-1).*diff(CSIClose)];    % Return
sh = sqrt(250)*sharpe(r,0);              % Annual Sharpe Ratio

% 绘制初步策略的评估结果
figure
ax(1) = subplot(2,1,1);
plot([CSIClose,lead,lag]); grid on
legend('Close','Lead','Lag','Location','Best')
title(['First Pass Results, Annual Sharpe Ratio = ',num2str(sh,3)])
ax(2) = subplot(2,1,2);
plot([s,cumsum(r)]); grid on
title(['Final Return = ',num2str(sum(r),3),' (',num2str(sum(r)/CSIClose(1)*100,3),'%)'])
legend('Position','Cumulative Return','Location','Best')
linkaxes(ax,'x')
annualScaling = sqrt(250);

%% 2 选择最佳的移动均线参数
% 采用参数扫描的方法选择遍历可选的参数并选择最佳的一组.
clear s lead lag r sh
sh = nan(100,100);
cost=0;
scaling = sqrt(250);
tic
for n = 1:100  
    for m = n:100
        s = zeros(size(CSIClose));
        [lead,lag] = movavg(CSIClose,n,m,'e');
        s(lead>lag) = 1;
        s(lag>lead) = -1;
        r  = [0; s(1:end-1).*diff(CSIClose)-abs(diff(s))*cost/2];
        sh(n,m) = scaling*sharpe(r,0);
        clear s lead lag r
    end
end
toc
figure
surfc(sh), shading interp, lighting phong
view([80 35]), light('pos',[0.5, -0.9, 0.05])
colorbar

% 绘制最佳的夏普率
[maxSH,row] = max(sh);    % max by column
[maxSH,col] = max(maxSH); % max by row and column
figure
% leadlag(CSIClose,row(col),col,annualScaling)
[lead,lag] = movavg(CSIClose,row(col),col,'e');
plot([CSIClose,lead,lag]); grid on

% 评估当前策略
clear lead lag
figure
[lead,lag] = movavg(CSICloseV,row(col),col,'e');
plot([CSICloseV,lead,lag]); grid on




