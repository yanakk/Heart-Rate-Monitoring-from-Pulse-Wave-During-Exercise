% signal = allDataMatrix(:,4);
signal = res_signal;
% signal = qvr_signal;
% signal = enlms;
windowLen = 200;
count = 0;
Lc = 2;
Rc = 3;
FHR = [];
statusVector = 0;bpmVector = zeros(2,5);bpmValue = [];
intRegister = []; intLen = 30;

%% SVD
SFFF = []; SRN = [];

for i = 1:srate:length(res_signal)-srate*10
    if isempty(bpmValue)    % determine previous major frequency
        pre_mf = 1.5;   % default
    else
        pre_mf = bpmValue(end)/60;
    end
    
    % Doing SVD        can use pre_mf
    temp = SSA(signal(i:i+srate*10),windowLen,1,1); % result
    [fs,mf] = FreqSA(temp);
    res = abs(mf-pre_mf);   % res<0.3   mf>1 && mf < 2.6
    if res<0.3
        Lc = 1;Rc = 1;
    else
        temp = SSA(signal(i:i+srate*10),windowLen,2,2); % result
        [fs,mf] = FreqSA(temp); res = abs(mf-pre_mf);
        if res<0.3
            Lc = 2;Rc = 3;
        else
%             Lc = 0; Rc = 0; % raw signal
%             Lc = 2;Rc = 3;

            for j = 3:1:20
                temp = SSA(signal(i:i+srate*10),windowLen,j,j); % result
                 [fs,mf] = FreqSA(temp);    res = abs(mf-pre_mf);
                  if res<0.3
                      break;
                  end
            end
            Lc = j; Rc = j;
            if j == 20
                Lc = 0; Rc = 0; % raw signal
                disp(j);
            end

        end
    end
    
    if Lc == 0
        SsignalFiltered = signal(i:i+srate*10)'/10000; %stay same
        disp(Lc);
    else
        temp = SSA(signal(i:i+srate*10),windowLen,Lc,Rc); SsignalFiltered = temp;
        temp = SSA(signal(i:i+srate*10),windowLen,1,Lc-1) ;SFFF = temp;
        temp = SSA(signal(i:i+srate*10),windowLen,Rc+1,windowLen) ;SRN = temp;
    end
    
    figure(1)
    subplot(4, 1, 1);
    plot(signal(i:i+srate*10));
    title('Signal Before SSA','FontWeight','bold','FontSize',16);
    subplot(4, 1, 2);
    plot([SFFF]);
    title('Removed Main Parts','FontWeight','bold','FontSize',16);
    subplot(4, 1, 3);
    plot([SRN]);
    title('Removed Random Noise','FontWeight','bold','FontSize',16);
    subplot(4, 1, 4);
    plot([SsignalFiltered]);
    title('Signal After SSA','FontWeight','bold','FontSize',16);
    
    % Cal Time-domain HR
    int_SsignalFiltered = SsignalFiltered*10000;
    [int_SsignalFiltered,intRegister] = integralFunc(int_SsignalFiltered',intLen,intRegister);
    [PEAKS,statusVector] = findRPeakFunc(int_SsignalFiltered,srate,7,statusVector);
    bpmVector = calcBPMFunc(PEAKS,srate,bpmVector);
%     disp(bpmVector);
    if isempty(bpmValue) && bpmVector(1,end)>40
        bpmValue(end+1) = bpmVector(1,end);
    elseif isempty(bpmValue) && bpmVector(1,end)<40
        bpmValue(end+1) = 90;
    elseif bpmVector(1,end) > 50 && bpmVector(1,end) < 160 && abs(bpmVector(1,end) - bpmValue(end))<10
        bpmValue(end+1) = bpmVector(1,end);
    elseif bpmVector(1,end) - bpmValue(end) > 0
        bpmValue(end+1) = bpmValue(end)+1;  % stay same
        count = count+1;
    elseif bpmVector(1,end) - bpmValue(end) < 0
        bpmValue(end+1) = bpmValue(end)-1;  % stay same
        count = count+1;
    end
    pre_mf = bpmValue(end)/60;
    
    % Cal Freq-domain HR
    if isempty(FHR)
        [fs,mf] = WeiVerFreqSA(SsignalFiltered,90,12,srate);
    else
        [fs,mf] = WeiVerFreqSA(SsignalFiltered,FHR(end),12,srate);
    end

    plot(SsignalFiltered);
    R_FHR = mf*60;
%     disp(R_FHR);
    if isempty(FHR)    % if initial
        if R_FHR > 50 && R_FHR < 130
            FHR(end+1) = mf*60;
        end
    else
        if R_FHR > 50 && R_FHR < 160 && abs(R_FHR - FHR(end))<10
            FHR(end+1) = mf*60;
        elseif R_FHR - FHR(end) > 0
            FHR(end+1) = FHR(end)+1;  % stay same
            count = count+1;
        elseif R_FHR - FHR(end) < 0
            FHR(end+1) = FHR(end)-1;  % stay same
            count = count+1;
        end
        
    end

end

figure(2);
plot(FHR);
hold on;
plot(bpmValue);
hold on;
% plot(bpmShoesMatrix);
plot(ECG_HR(10:end));
legend('SSA-FFT HR','SSA-Time HR','ECG')
xlabel('Second')
ylabel('BPM')
title('HR results comparison')
