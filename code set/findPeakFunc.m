function [PEAKS] = findPeakFunc(inputData,judgeSlopeLen, judgeSlopeThreshold)

%find peaks
PEAKS.Mag = [];
PEAKS.Index = [];
PEAKS.Num = 0;


for k = judgeSlopeLen+1:length(inputData)-judgeSlopeLen
    if max(inputData(k-judgeSlopeLen:k+judgeSlopeLen)) == inputData(k)
        if sum(diff(inputData(k-judgeSlopeLen:k-1))) > judgeSlopeThreshold && sum(diff(inputData(k+1:k+judgeSlopeLen))) ...
                < -judgeSlopeThreshold
            PEAKS.Mag = [PEAKS.Mag,inputData(k)];
            PEAKS.Index = [PEAKS.Index,k];
            PEAKS.Num = PEAKS.Num + 1;
        end
    end
end


