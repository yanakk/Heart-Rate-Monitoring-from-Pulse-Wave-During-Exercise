
status = 0;     % 0: Double slope   1: SSA+time   2: RAW
count = 0;

if status == 0  % FORMER METHOD
registerWin = [];
[DSPoutputData,registerWin] = doubleSlopeProc(res_signal',srate,registerWin);
F = load('lowpassF.mat');
[b,a]=sos2tf(F.SOS,F.G);
DSPoutputData = filter(b, a, DSPoutputData);

intRegister = []; intLen = 30;
[integralData,intRegister] = integralFunc(DSPoutputData,intLen,intRegister);

statusVector = 0;bpmVector = zeros(2,5);bpmValue = [];
% [PEAKS,statusVector] = findRPeakFunc(integralData,srate,7,statusVector);
% bpmVector = calcBPMFunc(PEAKS,srate,bpmVector); bpmValue = bpmVector(1,end);

for i = 1:srate:length(integralData)-srate*10
    [PEAKS,statusVector] = findRPeakFunc(integralData(i:i+srate*10),srate,7,statusVector);
    bpmVector = calcBPMFunc(PEAKS,srate,bpmVector);
    if isempty(bpmValue)
        bpmValue(end+1) = bpmVector(1,end);
    elseif bpmVector(1,end) > 40 && bpmVector(1,end) < 160 && abs(bpmVector(1,end) - bpmValue(end))<10
        bpmValue(end+1) = bpmVector(1,end);
    elseif bpmVector(1,end) - bpmValue(end) > 0
        bpmValue(end+1) = bpmValue(end)+1;  % stay same
        count = count+1;
    elseif bpmVector(1,end) - bpmValue(end) < 0
        bpmValue(end+1) = bpmValue(end)-1;  % stay same
        count = count+1;
    end

end
plot(bpmValue);
end

if status == 1  % SVD
int_signalFiltered = signalFiltered*10000;
[int_signalFiltered,intRegister] = integralFunc(int_signalFiltered',intLen,intRegister);

statusVector = 0;bpmVector = zeros(2,5);bpmValue = [];
% [PEAKS,statusVector] = findRPeakFunc(integralData,srate,7,statusVector);
% bpmVector = calcBPMFunc(PEAKS,srate,bpmVector); bpmValue = bpmVector(1,end);

for i = 1:srate:length(integralData)-srate*10
    [PEAKS,statusVector] = findRPeakFunc(int_signalFiltered(i:i+srate*10),srate,7,statusVector);
    bpmVector = calcBPMFunc(PEAKS,srate,bpmVector); 
    if isempty(bpmValue)
        bpmValue(end+1) = bpmVector(1,end);
    elseif bpmVector(1,end) > 40 && bpmVector(1,end) < 160 && abs(bpmVector(1,end) - bpmValue(end))<12
        bpmValue(end+1) = bpmVector(1,end);
    elseif bpmVector(1,end) - bpmValue(end) > 0
        bpmValue(end+1) = bpmValue(end)+1;  % stay same
        count = count+1;
    elseif bpmVector(1,end) - bpmValue(end) < 0
        bpmValue(end+1) = bpmValue(end)-1;  % stay same
        count = count+1;
    end
    
end
plot(bpmValue);
end

if status == 2  % RAW

statusVector = 0;bpmVector = zeros(2,5);bpmValue = [];
% [PEAKS,statusVector] = findRPeakFunc(integralData,srate,7,statusVector);
% bpmVector = calcBPMFunc(PEAKS,srate,bpmVector); bpmValue = bpmVector(1,end);

for i = 1:srate:length(res_signal)-srate*10
    [PEAKS,statusVector] = findRPeakFunc(res_signal(i:i+srate*10),srate,7,statusVector);
    bpmVector = calcBPMFunc(PEAKS,srate,bpmVector); 
    if isempty(bpmValue) && bpmVector(1,end)>40
        bpmValue(end+1) = bpmVector(1,end);
    elseif isempty(bpmValue) && bpmVector(1,end)<40
        bpmValue(end+1) = 110;
    elseif bpmVector(1,end) > 40 && bpmVector(1,end) < 160 && abs(bpmVector(1,end) - bpmValue(end))<12
        bpmValue(end+1) = bpmVector(1,end);
    elseif bpmVector(1,end) - bpmValue(end) > 0
        bpmValue(end+1) = bpmValue(end)+1;  % stay same
        count = count+1;
    elseif bpmVector(1,end) - bpmValue(end) < 0
        bpmValue(end+1) = bpmValue(end)-1;  % stay same
        count = count+1;
    end
    
end
plot(bpmValue);
end
