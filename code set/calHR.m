clc;
% load('14-Jul-2020-static.mat');
% xx = signalFiltered;
% xx = qvr_signal;
xx = res_signal;
% xx = allDataMatrix(:,4);
% Fs = 125;   % sample rate 125Hz
% interval = 0.008;   % 1/125
% 
% plot(xx)
% 
% initial_check = int32(0.56/interval);
% % HR = 60;
% % move = 60.0/(0.008*0.2*HR);
% Len = length(xx);
% check = initial_check;
% A = [];
% HR = [];
% rate = 0.8;
% pt = initial_check;
% 
% % 根据实时心率更新判断范围
% for i = 1:(Len - 2*initial_check)
%    pt = pt + 1; 
%    if pt + check > Len
%        break
%    end
%    
%    temp = xx(pt-check:pt+check);    % search in the specific field
%    maxx = max(temp);
%    (end)-A(end-1);
%            HR(end+1) = 60.0/(dn*interval);
%            check = int32(rate*60/(interval*HR(end)));
%        end
%    end
% 
% end

[HR,MeanHR,Peak] = HRcalFun(xx);
hold on;
plot(MeanHR);
hold on;
plot(HR);
hold on;
plot(ECG_HR);
legend('Mean HR','Instant HR','ECG')
ylabel('BPM')
title('HR results by Time-domain')
