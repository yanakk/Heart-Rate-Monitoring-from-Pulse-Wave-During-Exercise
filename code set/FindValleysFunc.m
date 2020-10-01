function [VALLEYS] = FindValleysFunc(inputData,judgeSlopeLen, judgeSlopeThreshold)

%find valleys
VALLEYS.Mag = [];
VALLEYS.Index = [];
VALLEYS.Num = 0;

for k = judgeSlopeLen+1:length(inputData)-judgeSlopeLen    
    if min(inputData(k-judgeSlopeLen:k+judgeSlopeLen)) == inputData(k)
        if sum(diff(inputData(k-judgeSlopeLen:k-1))) < -judgeSlopeThreshold && sum(diff(inputData(k+1:k+judgeSlopeLen))) ...
                > judgeSlopeThreshold
            VALLEYS.Mag = [VALLEYS.Mag,inputData(k)];
            VALLEYS.Index = [VALLEYS.Index,k];
            VALLEYS.Num = VALLEYS.Num + 1;
        end
    end
end