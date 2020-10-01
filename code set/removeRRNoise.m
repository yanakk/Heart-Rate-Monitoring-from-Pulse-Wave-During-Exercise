function rrIntervalIndex = removeRRNoise(pDiffIndex,fs,bpmVector)

%%rrIntervalTime = 4;
rrIntervalTime = 10; %%for 125Hz
indexNum = length(pDiffIndex);

rrIntervalIndex = [];
if indexNum <= 2 && indexNum >= 1
    if sum(bpmVector(2,1:end-1)) > 0
        rrIntervalIndex = pDiffIndex(find(abs(pDiffIndex - 60/bpmVector(1,end-1)*fs) < rrIntervalTime));
    end
elseif indexNum >= 3%more than 3
    if sum(bpmVector(2,1:end-1)) > 0
        rrIntervalIndex = pDiffIndex(find(abs(pDiffIndex - 60/bpmVector(1,end-1)*fs) < rrIntervalTime));
    else
        while 1
            meanRR = mean(pDiffIndex);%averge RR
            noiseIndex = find(abs(pDiffIndex - meanRR) >= rrIntervalTime);
            pDiffIndex(noiseIndex) = [];
            if length(pDiffIndex) >= 3 && isempty(noiseIndex)
                rrIntervalIndex = pDiffIndex;
                break;
            elseif length(pDiffIndex) < 3
                break;
            end
        end
    end
end
