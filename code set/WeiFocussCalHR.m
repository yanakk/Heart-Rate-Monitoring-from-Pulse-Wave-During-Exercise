count = 0;
N = 4096;
% Y = res_signal;
Y = signalFiltered(1:end);
s = length(Y);
fs = 116;   % 125 or 70
lambda = 0.1;
SSR_HR = [];
WL = 1160;
% M = length(Y);

Phi = zeros(WL,N);

binwidth = fs/N;
f=[0:binwidth:fs-binwidth];

for i = WL+1:WL/10:s
    ys = Y(i-WL:i);
    M = length(ys);
    for m = 1:M
        for n = 1:N
            Phi(m,n) = exp(j*(2*pi*m*n/N));
        end
    end
    
    [X_focuss] = OrigFocuss(ys,Phi,5);
    X_focuss = abs(X_focuss);
    figure(1);
    plot(Y(i-WL:i));
    
    if isempty(SSR_HR)
        Lm = (60/60/binwidth)+1; Rm =(110/60/binwidth)+1;  % LIMIT
    else
        Lm = ((SSR_HR(end)-10)/60/binwidth)+1; Rm =((SSR_HR(end)+10)/60/binwidth)+1;  % LIMIT
    end
%     [m,index] = max(X_focuss(1:N/2));
%      RSSR_HR = (index-1)*binwidth*60;
    range = X_focuss(Lm:Rm);
    [m,index] = max(range);
    k = find(range>m/2,5);
    weight = [];
    iindex =[];
    for q = 1:length(k)
        weight(end+1) = range(k(q))/m;
    end
    for q = 1:length(k)
        iindex(end+1) = (k(q)-1+Lm-1)*binwidth *weight(q)*60;
    end
     RSSR_HR = sum(iindex) / sum(weight);
%      RSSR_HR = (index-1+Lm-1)*binwidth*60;
   
    disp(RSSR_HR);
    disp(i/s);
    
    if isempty(SSR_HR)    % if initial
        if RSSR_HR > 60 && RSSR_HR < 110
            SSR_HR(end+1) = RSSR_HR;
        end
    else
        if RSSR_HR > 50 && RSSR_HR < 110 && abs(RSSR_HR - SSR_HR(end))<10
            SSR_HR(end+1) = RSSR_HR;
        elseif RSSR_HR - SSR_HR(end) > 0
            SSR_HR(end+1) = SSR_HR(end)+1;
            count = count + 1;
        elseif RSSR_HR - SSR_HR(end) < 0
            SSR_HR(end+1) = SSR_HR(end)-1;
            count = count + 1;
        end
        
    end
    figure(2);
    plot(f(1:N/2),X_focuss(1:N/2));
    xlim([0 10]);
end
% disp(SSR_HR);

figure(3);
plot(SSR_HR);
hold on;
plot(FHR);
hold on;
plot(ECG_HR(11:end));
hold on;
plot(ECG_HR(11:end));
legend('SSR HR','FFT HR','ECG HR');
ylabel('BPM');
title('BPM Results (Walking)','FontWeight','bold','FontSize',18);
ylim([60 110]);
