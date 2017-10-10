%% ���������ھ����ĳ���ѡ��step6: Ͷ������Ż�
%������Ͷ�ʣ������ھ�����ʵ������15�����׳��򣬵��ӹ�ҵ�����磬׿����ȱ�����70263215@qq.com 
%% ��ȡ����
clc, clear all, close all
sdata = xlsread('forecast_result.xlsx');
isn = 8; %Ͷ�ʵĹ�Ʊ��
dn=200;  %����
isid= sdata(1:isn, 1);
dirname = 'sz1000_data';
 k1='00000';    k2='0000';    k3='000';    k4='00';
for i=1:isn  
     dsid = isid(i);
           if  dsid<3000
           d=num2str(dsid);
             if dsid<10
               kk=[k1,d];
             elseif (10<=dsid)&&(dsid<100)
               kk=[k2,d];
             elseif (100<=dsid)&&(dsid<1000)
               kk=[k3,d];
             elseif (1000<=dsid)&&(dsid<10000)
               kk=[k4,d];
             end
           end 
    head='sz';
    tail='.xls';
    fname=[head,kk, tail];
    filename = fullfile(dirname, fname);
    price = xlsread(filename);  
    CP(:,i)=price(1:dn, 5);
     clear price 
    end

%% ����ر�
Returns = tick2ret(CP);
figure;
plot(Returns);  title('��Ʊ�ر�����ͼ');
set(get(gcf,'Children'),'YLim',[-0.5 0.5]); % ȷ��Y������߶���ͬ

%% ��Ʊ���
assetTickers = {'p1', 'p2', 'p3','p4', 'p5', 'p6', 'p7','p8'};
%% ����Ͷ����Ϸ�������
pmc = PortfolioCVaR;
pmc = pmc.setAssetList(assetTickers);
pmc = pmc.setScenarios(Returns);
pmc = pmc.setDefaultConstraints;
pmc = pmc.setProbabilityLevel(0.95);

% ������Чǰ������
figure; [pmcRisk, pmcReturns] = pmc.plotFrontier(10);
%% ����Ͷ�������������
pmv = Portfolio;
pmv = pmv.setAssetList(assetTickers);
pmv = pmv.estimateAssetMoments(Returns);
pmv = pmv.setDefaultConstraints;
% ������������ǰ������
figure; pmv.plotFrontier(10);

%% ���㲢��ʾȨ�������
pmcwgts = pmc.estimateFrontier(10);
pmcRiskStd = pmc.estimatePortStd(pmcwgts);
figure;
pmv.plotFrontier(10);
hold on
plot(pmcRiskStd,pmcReturns,'-r','LineWidth',2);
legend('Mean-Variance Efficient Frontier',...
       'CVaR Efficient Frontier',...
       'Location','SouthEast')
   
%% �Ƚ�Ͷ��Ȩ��
pmvwgts = pmv.estimateFrontier(10);
figure; 
subplot(1,2,1);
area(pmcwgts');
title('CVaR Ͷ�����Ȩ��');
subplot(1,2,2);
area(pmvwgts');
title('Mean-Variance Ͷ�����Ȩ��');
set(get(gcf,'Children'),'YLim',[0 1]);
legend(pmv.AssetList);

%% ����Ͷ��ƫ��ѡ��Ͷ����Ϸ���
mrisk = 0.02; % ������շ�ֵ
% Ѱ���ڲ��������շ�ֵ�����Ԥ����������һ��Ͷ�����
sid = pmcRiskStd <= mrisk;
nid = find(pmcRiskStd == max(pmcRiskStd(sid)))
disp(['���Ͷ�ʱ���:' num2str(pmcwgts(:,nid)')]);
%% ˵�������Ը��ݷ���ƫ��ѡ��Ͷ�����


