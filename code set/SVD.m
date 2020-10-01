% F = load('lowpassF.mat');
% [b,a]=sos2tf(F.SOS,F.G);
% res_signal = filter(b, a, res_signal);

% signal = allDataMatrix(:,4);
signal = res_signal;
% signal = qvr_signal;
% signal = enlms;
windowLen = 200;
Lc = 2;
Rc = 2;

[signalFiltered , FFF , RN ]= deal(zeros(length(signal),1));
for i = 1:srate*10:length(res_signal)-srate*20
    temp = SSA(signal(i:i+srate*10),windowLen,1,1);
    [fs,mf] = FreqSA(temp);
    if mf>1 && mf < 2.5
        Lc = 1;Rc = 1;
    else
        Lc = 2;Rc = 3;
    end
    temp = SSA(signal(i:i+srate*10),windowLen,Lc,Rc); signalFiltered(i:i+srate*10) = temp;
    temp = SSA(signal(i:i+srate*10),windowLen,1,Lc-1) ;FFF(i:i+srate*10) = temp;
    temp = SSA(signal(i:i+srate*10),windowLen,Rc+1,windowLen) ;RN(i:i+srate*10) = temp;
end
temp = SSA(signal(i:end),windowLen,Lc,Rc); signalFiltered(i:end) = temp;
temp = SSA(signal(i:end),windowLen,1,Lc-1) ;FFF(i:end) = temp;
temp = SSA(signal(i:end),windowLen,Rc+1,windowLen) ;RN(i:end) = temp;

% signalFiltered = SSA(signal,windowLen,Lc,Rc);
% FFF = SSA(signal,windowLen,1,Lc-1) ;
% RN = SSA(signal,windowLen,Rc+1,windowLen) ;

figure(1)
subplot(4, 1, 1);
plot(signal);
title('Signal Before SSA','FontWeight','bold','FontSize',16);
subplot(4, 1, 2);
plot([FFF]);
title('Removed Main Parts','FontWeight','bold','FontSize',16);
subplot(4, 1, 3);
plot([RN]);
title('Removed Random Noise','FontWeight','bold','FontSize',16);
subplot(4, 1, 4);
plot([signalFiltered]);
title('Signal After SSA','FontWeight','bold','FontSize',16);
[fs,mf] = FreqSA(signalFiltered);
disp(mf)
