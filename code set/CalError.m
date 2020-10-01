sum = 0;
E = 0;
error = [];
% sprate = 125;
% ECG_HR = [];
% for i = 1:3:length(ECG)
%     ECG_HR(end+1) = (ECG(i) + ECG(i+1)+ECG(i+2))/3;
% end

% ECG_HR = [];
% for i = 1:4:length(ECG)
%     ECG_HR(end+1) = (ECG(i) + ECG(i+1)+ECG(i+2)+ECG(i+3))/4;
% end

% AC_Pressure = allDataMatrix(:,3);
% t8=0:1/sprate:(length(AC_Pressure)-1)/sprate;
% F = load('lowpassF.mat');
% [b,a]=sos2tf(F.SOS,F.G);
% AC_Pressure = filter(b, a, AC_Pressure);
% [res_signal] = MoveBSL(AC_Pressure,t8);
% qvr_signal = baseline(AC_Pressure,20);

drift = 10;
for i = 1:1:length(FHR)
    error(end+1) = FHR(i)-ECG_HR(i+drift);
    sum = sum + abs(error(end));
    E = E + ((FHR(i)-ECG_HR(i+drift)).^2);
end
sum = sum / length(FHR)
RMSE= sqrt(E/length(FHR))

% drift = 10;
% for i = 1:1:length(bpmValue)
%     error(end+1) = bpmValue(i)-ECG_HR(i+drift);
%     sum = sum + abs(error(end));
%     E = E + ((bpmValue(i)-ECG_HR(i+drift)).^2);
% end
% sum = sum / length(bpmValue)
% RMSE= sqrt(E/length(bpmValue))

% for i = 1:1:length(SSR_HR)
%     error(end+1) = SSR_HR(i)-ECG_HR(i+10);
%     sum = sum + abs(error(end));
% end
% sum = sum / length(SSR_HR)
