function [PEAKS,statusVector] = findRPeakFunc(inputData,fs,judgeSlopeLen,statusVector)

%find peaks
PEAKS.Mag = [];
PEAKS.Index = [];
PEAKS.Num = 0;

%threhold %%for 125Hz
SLOPETHROLD = 0.3;
MINMAG = 2;
%MAXMAG = 750;
MAXMAG = 2000;

statusVector(1:end-1) = statusVector(2:end);

statusThrelod = max(inputData(end-fs+1:end));
if statusThrelod < MAXMAG
    statusVector(end) = 0;%not moving
elseif statusThrelod < 2*MAXMAG
    statusVector(end) = 1;%walk slowly
elseif statusThrelod < 3.5*MAXMAG
    statusVector(end) = 2;%walk quickly
else
    statusVector(end) = 3;%run
end
if all(statusVector)
    return;
end

for k = judgeSlopeLen+1:length(inputData)-judgeSlopeLen
    if max(inputData(k-judgeSlopeLen:k+judgeSlopeLen)) == inputData(k)
        if sum(diff(inputData(k-judgeSlopeLen:k-1))) > SLOPETHROLD && sum(diff(inputData(k+1:k+judgeSlopeLen))) ...
                < -SLOPETHROLD && inputData(k) > MINMAG && inputData(k) < MAXMAG
            PEAKS.Mag = [PEAKS.Mag,inputData(k)];
            PEAKS.Index = [PEAKS.Index,k];
            PEAKS.Num = PEAKS.Num + 1;
            
            if (PEAKS.Num >= 20)
                break;
            end
        end
    end
end

