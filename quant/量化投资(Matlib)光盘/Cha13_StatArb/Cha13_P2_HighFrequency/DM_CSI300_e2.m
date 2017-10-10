%% ��Ƶ����
%������Ͷ�ʣ������ھ�����ʵ������13�����׳��򣬵��ӹ�ҵ�����磬׿����ȱ�����70263215@qq.com
%% ׼������
clc, clear all, close all
load CSI300.mat
CSI300_1Mn = raw_CSI300_1Mn(:, 4);
CSI300_1Mn = CSI300_1Mn(1:end);
CSI300_EOD = raw_CSI300_EOD(:, 4);
testPts = floor(0.8*length(CSI300_EOD));
CSIClose = CSI300_EOD(1:testPts);
CSICloseV = CSI300_EOD(testPts+1:end);

%% ����ָ��
[lead,lag]=movavg(CSIClose,20,30,'e');
plot([CSIClose,lead,lag]), grid on
legend('Close','Lead','Lag','Location','Best')

s = zeros(size(CSIClose));
s(lead>lag) = 1;                         % Buy  (long)
s(lead<lag) = -1;                        % Sell (short)
r  = [0; s(1:end-1).*diff(CSIClose)];   % Return
sh = sqrt(250)*sharpe(r,0);              % Annual Sharpe Ratio

%% ��ʾ���Խ��

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


%% �����Ż�
% Return to the two moving average case and identify the best one.
sh = nan(100,100);
tic
for n = 1:100  
    for m = n:100
        [~,~,sh(n,m)] = leadlag(CSIClose,n,m,annualScaling);
    end
end
toc

figure
surfc(sh), shading interp, lighting phong
view([80 35]), light('pos',[0.5, -0.9, 0.05])
colorbar

%% ������� Sharpe Ratio
[maxSH,row] = max(sh);    % max by column
[maxSH,col] = max(maxSH); % max by row and column
leadlag(CSIClose,row(col),col,annualScaling)
leadlag(CSICloseV,row(col),col,annualScaling)

%% �������׳ɱ�
cost=0.01; % bid/ask spread
range = {1:1:120,1:1:120};
annualScaling = sqrt(250);
llfun =@(x) leadlagFun(x,CSIClose,annualScaling,cost);

tic
[maxSharpe,param,sh,vars] = parameterSweep(llfun,range);
toc

figure
surfc(vars{1},vars{2},sh), shading interp, lighting phong
title(['Max Sharpe Ratio ',num2str(maxSharpe,3),...
    ' for Lead ',num2str(param(1)),' and Lag ',num2str(param(2))]);
view([80 35]), light('pos',[0.5, -0.9, 0.05])
colorbar
figure
leadlag(CSICloseV,row(col),col,annualScaling,cost)

%% ȷ����ѵĽ���Ƶ��
close all
testPts = floor(0.8*length(CSI300_1Mn));
CSIClose = CSI300_1Mn(1:testPts);
CSICloseV = CSI300_1Mn(testPts+1:end);
cost=0.01; % bid/ask spread

%% ����ɨ��
seq = [1:19 20:5:100];
ts = 1:20;
range = {seq,seq,ts};
annualScaling = sqrt(250*4*60);
llfun =@(x) leadlagFun(x,CSIClose,annualScaling,cost);

tic
[~,param,sh,xyz] = parameterSweep(llfun,range);
toc

%%
leadlag(CSIClose(1:param(3):end),param(1),param(2),...
        sqrt(annualScaling^2/param(3)),cost)
xlabel(['Frequency (',num2str(param(3)),' minute intervals)'])
%%
% Plot iso-surface
figure
redvals = 1.2:0.1:1.9;
yelvals = 0.3:0.1:1;
bluevals=0:0.1:0.4;
isoplot(xyz{3},xyz{1},xyz{2},sh,redvals,yelvals,bluevals)
set(gca,'view',[-21, 18],'dataaspectratio',[3 1 3])
grid on, box on
% labels
title('Iso-surface of Sharpes ratios.','fontweight','bold')
zlabel('Slow Mov. Avg.','Fontweight','bold');
ylabel('Fast Mov. Avg.','Fontweight','bold');
xlabel('Frequency (minutes)','Fontweight','bold');
colorbar

%%
seq = 1:60;
% ts  = [1:4 5:5:55 60:10:180 240 480];
ts = 5:5:60;
range = {seq,seq,ts};
annualScaling = sqrt(250*4*60);
llfun =@(x) leadlagFun(x,CSIClose,annualScaling,cost);

tic
[maxSharpe,param,sh,xyz] = parameterSweep(llfun,range);
toc

%%
param;      
leadlag(CSIClose(1:param(3):end),param(1),param(2),...
        sqrt(annualScaling^2/param(3)),cost)
xlabel(['Frequency (',num2str(param(3)),' minute intervals)'])

%% ������֤
leadlag(CSICloseV(1:param(3):end),param(1),param(2),...
        sqrt(annualScaling^2/param(3)),cost)
xlabel(['Frequency (',num2str(param(3)),' minute intervals)'])



