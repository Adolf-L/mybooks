function varargout = pairs(series2, M, N, spread, scaling, cost)
%�ú�������һ��һ�齻���ź�
%% �����������
if ~exist('scaling','var')
    scaling = 1;
end

if ~exist('cost','var')
    cost = 0;
end

if ~exist('spread', 'var')
    spread = 1;
end

if nargin == 1
    M = 420;
    N = 60;
elseif nargin == 2
    error('PAIRS:NoRebalancePeriodDefined',...
        'When defining a lookback window, the rebalancing period must also be defined')
end

warning('off', 'econ:egcitest:LeftTailStatTooSmall')
warning('off', 'econ:egcitest:LeftTailStatTooBig')

%% ɨ������ʱ�����е�Э����ϵ
s = zeros(size(series2));
indicate = zeros(length(series2),1);

for i = max(M,N) : N : length(s)-N
       try
        [h,~,~,~,reg1] = egcitest(series2(i-M+1:i, :));
    catch
        h = 0; 
    end
    if h ~= 0
         res = series2(i:i+N-1, 1) ...
            - (reg1.coeff(1) + reg1.coeff(2).*series2(i:i+N-1, 2));
        
         indicate(i:i+N-1) = res/reg1.RMSE;
        
        s(i:i+N-1, 1) = -(res/reg1.RMSE > spread) ...
            + (res/reg1.RMSE < -spread);
        s(i:i+N-1, 2) = -reg1.coeff(2) .* s(i:i+N-1, 1);
    end
end

%% ��������ͳ����
trades  = [0 0; 0 0; diff(s(1:end-1,:))]; % shift trading by 1 period
cash    = cumsum(-trades.*series2-abs(trades)*cost/2);
pandl   = [0 0; s(1:end-1,:)].*series2 + cash;
pandl   = pandl(:,1)-pandl(:,2);
r = [0; diff(pandl)];
sh = scaling*sharpe(r,0);

if nargout == 0
    %% ���ƽ��
    ax(1) = subplot(3,1,1);
    plot(series2), grid on
    legend('LCO','WTI')
    title(['Pairs trading results, Sharpe Ratio = ',num2str(sh,3)])
    ylabel('Price (USD)')
    
    ax(2) = subplot(3,1,2);
    plot([indicate,spread*ones(size(indicate)),-spread*ones(size(indicate))])
    grid on
    legend(['Indicator'],'LCO: Over bought','LCO: Over sold',...
        'Location','NorthWest')
    title(['Pairs indicator: rebalance every ' num2str(N)...
        ' minutes with previous ' num2str(M) ' minutes'' prices.'])
    ylabel('Indicator')
    
    ax(3) = subplot(3,1,3);
    plot([s,cumsum(r)]), grid on
    legend('Position for LCO','Position for WTI','Cumulative Return',...
        'Location', 'NorthWest')
    title(['Final Return = ',num2str(sum(r),3),' (',num2str(sum(r)/mean(series2(1,:))*100,3),'%)'])
    ylabel('Return (USD)')
    xlabel('Serial time number')
    linkaxes(ax,'x')
else
    %% ���ر���
    for i = 1:nargout
        switch i
            case 1
                varargout{1} = s; % �ź�
            case 2
                varargout{2} = r; % ���� (pnl)
            case 3
                varargout{3} = sh; % ������
            case 4
                varargout{4} = indicate; % ָ��
            otherwise
                warning('PAIRS:OutputArg',...
                    'Too many output arguments requested, ignoring last ones');
        end 
    end
end
