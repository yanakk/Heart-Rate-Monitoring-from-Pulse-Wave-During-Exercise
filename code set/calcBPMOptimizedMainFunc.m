
%function [bpmValue,rpmValue,PEAKS,BR_VALLEYS,shoesOffFlag, wearProperlyFlag] = calcBPMOptimizedMainFunc(data,fs)
function [bpmValue,PEAKS,BR_VALLEYS] = calcBPMOptimizedMainFunc(data,fs)   
   global  WindowLen channelIndex invalidHeartRateVector shoesOnFlag  wearProperlyFlag respirationRateSourceFlag systemStartupFlag 

    %dbstop if all error;
   
    %initialize function outputs
    bpmValue = 0;  

    PEAKS.Mag = [];
    PEAKS.Index = [];
    PEAKS.Num = 0;

    BR_VALLEYS.Mag = [];
    BR_VALLEYS.Index = [];
    BR_VALLEYS.Num = 0;
    
    %thresholds
%     averageShoesOnSignalThreshold = 300;
%     maxShoesOnSignalThreshold = 1200;
%     baseSignalThreshold = 100;
%     movingDeltaThrehold = 600;   
    
    averageShoesOnSignalThreshold = 1000;
    maxShoesOnSignalThreshold = 1200;
    baseSignalThreshold = 600;
    movingDeltaThrehold = 2000;
    
    %at the system startup, proper initialization is carried out only ONE TIME regardless if channel is
    %preselected or not
    if (systemStartupFlag == 1)
        wearProperlyFlag = 1;
        invalidHeartRateVector = zeros(1,10);  
        calculationParameterInit(WindowLen * fs);
        systemStartupFlag = 0;
        
        %respirationRateSource = 1 => respiration rate calculation is based on the envelope of the pulse wave
        %respirationRateSource = 0 => respiration rate calculation is based on the correlation with heart rate
        respirationRateSourceFlag = 1;       
    end
    
    %at the system startup if the channel is not preselected or after resetting the system, reinitialization is required
    %invalidHeartRateVector => 1 : invalid heart rate; 0 : valid heart rate
    if (channelIndex == -1)        
        wearProperlyFlag = 1;        
        invalidHeartRateVector = zeros(1,10);           
        channelSelectionInit();
        calculationParameterInit(WindowLen * fs);   
        
        %respirationRateSource = 1 => respiration rate calculation is based on the envelope of the pulse wave
        %respirationRateSource = 0 => respiration rate calculation is based on the correlation with heart rate
        respirationRateSourceFlag = 1;       
    end
    
    shoesOnFlag = shoesOnFunc(data, averageShoesOnSignalThreshold, maxShoesOnSignalThreshold);    

    if (shoesOnFlag == 1)
        %if shoes are on
        if (channelIndex == 0)
            %if pulse wave channel is not selected
            channelAnalysisFunc(data,fs, baseSignalThreshold, movingDeltaThrehold);           
            return;                           
        end        
    else
        %if shoes are off, reset the system
        channelIndex = -1; 
        wearProperlyFlag = 0;
        return;
    end

    [bpmValue,PEAKS,BR_VALLEYS] = calculateVitalInfo(data, fs);   

    %decide if the calculated heart rate is valid or not
    if (bpmValue == 0)
        invalidityFlag = 1;
    else
        invalidityFlag = 0;
    end

    %update heart rate invalidity vector
    invalidHeartRateVector(1:end-1) = invalidHeartRateVector(2:end);
    invalidHeartRateVector(end) = invalidityFlag;

  
    
    %if heart rates for the most recent 10 seconds are all invalid
    if (sum(invalidHeartRateVector) == 10)
        %decide if the object is staionary or moving 
        deltaValue = max(data(:, channelIndex)) - min(data(:, channelIndex));
        if (deltaValue < movingDeltaThrehold)
            %object is stationary, reset the system
             channelIndex = -1;                 
             wearProperlyFlag = 0;
        end            
    end      
end
