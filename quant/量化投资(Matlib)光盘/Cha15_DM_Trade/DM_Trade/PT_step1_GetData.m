%% ���������ھ����ĳ���ѡ��step1:�ɼ����������Ʊ��������
%������Ͷ�ʣ������ھ�����ʵ������15�����׳��򣬵��ӹ�ҵ�����磬׿����ȱ�����70263215@qq.com 
%% ����׼������������
clc, clear all, close all
% ��������
connect=yahoo;
stattime='1/1/11';    % ʱ�����        
closetime='12/31/13';  %  ʱ���յ�
%% ��ȡ��Ʊ����
for i=1:1000  % Ŀ���Ʊ���
   % �������������Ʊ���� 
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
  %�ж��Ƿ���ڸù�Ʊ�����һ�ν��׼۸�Ϊ0��   
    test=fetch(connect,whole);
    if (test.Last == 0) 
       continue;
    end
  % ��ù�Ʊ�������� 
  price=fetch(connect,whole,stattime,closetime);
  
  %�����ݱ��浽���ص�excel
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
%% ˵�����ɼ������ݷ���ͬһĿ¼��data�ļ����¡�