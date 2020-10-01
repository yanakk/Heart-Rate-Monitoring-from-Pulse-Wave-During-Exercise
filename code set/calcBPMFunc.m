function bpmVector = calcBPMFunc(PEAKS,fs,bpmVector)

bpmVector(:,1:end-1) = bpmVector(:,2:end);
if PEAKS.Num <=2
    bpmVector(2,end) = 0;
    if sum(bpmVector(2,1:end-1)) == 0
        bpmVector(1,end) = 0;
    else
        bpmVector(1,end) = bpmVector(1,end-1);%predict filter
    end
elseif PEAKS.Num >= 3    
    diffIndex = diff(PEAKS.Index);
    pDiffIndex = [];
    for k = 1:length(diffIndex)
        if diffIndex(k) > 1/4*fs && diffIndex(k) < 3/2*fs 
            pDiffIndex = [pDiffIndex,diffIndex(k)];
        end
    end

     rrIntervalIndex = removeRRNoise(pDiffIndex,fs,bpmVector);
     if isempty(rrIntervalIndex)
         bpmVector(2,end) = 0;
         if sum(bpmVector(2,1:end-1)) == 0
             bpmVector(1,end) = 0;
         elseif sum(bpmVector(2,1:end-1)) == 1
             if sum(bpmVector(2,1:end-2)) == 1
                 bpmVector(1,end) = sum(bpmVector(1,end-2:end-1).*[0.2,0.8]);%predict filter
             else
                 bpmVector(1,end) = bpmVector(1,end-1);
             end
         else
             bpmVector(1,end) = sum(bpmVector(1,end-2:end-1).*[0.2,0.8]);%predict filter
         end
     else
         bpmVector(2,end) = 1;
         if sum(bpmVector(2,1:end-1)) == 0
             bpmVector(1,end) = 60/(mean(rrIntervalIndex)/fs);
         else
             bpmVector(1,end) = 60/(mean(rrIntervalIndex)/fs);%predict filter
         end
     end     
end

