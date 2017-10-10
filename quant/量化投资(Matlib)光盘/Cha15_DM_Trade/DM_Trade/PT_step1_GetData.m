%% 基于数据挖掘技术的程序化选股step1:采集深圳主板股票交易数据
%《量化投资：数据挖掘技术与实践》第15章配套程序，电子工业出版社，卓金武等编著，70263215@qq.com 
%% 环境准备及变量定义
clc, clear all, close all
% 参数定义
connect=yahoo;
stattime='1/1/11';    % 时间起点        
closetime='12/31/13';  %  时间终点
%% 获取股票数据
for i=1:1000  % 目标股票编号
   % 定义深圳主板股票代码 
    if  i<2725
    k1='00000';    k2='0000';    k3='000';    k4='00';
    d=num2str(i);
    if i<10
        kk=[k1,d];
    elseif (10<=i)&&(i<100)
        kk=[k2,d];
    elseif (100<=i)&&(i<1000)
        kk=[k3,d];
    elseif (1000<=i)&&(i<10000)
        kk=[k4,d];
    end 
    tail='.sz';
    whole=[kk,tail];
    end  
  %判断是否存在该股票（最后一次交易价格为0）   
    test=fetch(connect,whole);
    if (test.Last == 0) 
       continue;
    end
  % 获得股票交易数据 
  price=fetch(connect,whole,stattime,closetime);
  
  %将数据保存到本地的excel
   [p_r, p_c]=size(price);
   if p_r==0
       continue
   end
  price_data(:,1:6)=price(:,2:7);
  name_h='sz';
  name_t=kk;
  table_name=strcat(name_h, name_t);
  [p_r, p_c]=size(price);
  for ii=1:p_r
        price_date(ii,1)={datestr(price(ii,1),'yyyymmdd')};
  end
        
 xlswrite('\sz1000_data\table_name', price_date, 'sheet1',['A1:A' num2str(p_r)]);
 xlswrite('\dsz1000_data\table_name', price_data, 'sheet1',['B1:G' num2str(p_r)]);
 clear ii kk whole test price price_date price_data
end
%% 说明：采集的数据放在同一目录的data文件夹下。