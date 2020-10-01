function CalcBPFunc(sectionData, sectionDataLen, fs)
global BPregisterParLow BP_ProcData averagePeakBPSum averageValleyBPSum validPeakBPCount validValleyBPCount initFlag...
    averagePulseWaveDataPerSecond averagePressureDataPerSecond

    BPlowFilterB = [-0.00130380365992733,-0.00117812684590096,-0.00102349301681863,-0.000513962754442613,0.000758999671359885,0.00322144952228659,0.00724004279303479,0.0130455248325485,0.0206695696076718,0.0299064524171323,0.0403075944892486,0.0512121022523653,0.0618108122613549,0.0712359555642077,0.0786642669234644,0.0834189107988128,0.0850554102872040,0.0834189107988128,0.0786642669234644,0.0712359555642077,0.0618108122613549,0.0512121022523653,0.0403075944892486,0.0299064524171323,0.0206695696076718,0.0130455248325485,0.00724004279303479,0.00322144952228659,0.000758999671359885,-0.000513962754442613,-0.00102349301681863,-0.00117812684590096,-0.00130380365992733];
    BPlowFilterA = 1;
    
    pressCoeff = [1.36678553717316e-22,-6.38542800152623e-18,1.14509625936408e-13,-9.43907952405326e-10,3.45343973272325e-06,-0.00252102268581745,3.28119029644051];
    BPCoeff = [156.6908674633,93.59584754550453];
    
    % first second
     if initFlag == 0
         initFlag = 1;
         averagePulseWaveDataPerSecond = sectionData(1);
         averagePressureDataPerSecond = 13;
     end

    % Calibrate the pressure        
    CaliStandard = 5200;

    % sectionData = sectionData*(CaliStandard/mean(sectionData));
    sectionDataCal = sectionData*(CaliStandard/averagePulseWaveDataPerSecond);
    averagePulseWaveDataPerSecond = mean(sectionData);
    PressSecData = [sectionDataCal.^6,sectionDataCal.^5,sectionDataCal.^4,sectionDataCal.^3,sectionDataCal.^2,sectionDataCal.^1,sectionDataCal.^0]*pressCoeff';

    % Low pass filter
    [BPlowFilterData,BPregisterParLow] = filter(BPlowFilterB,BPlowFilterA,PressSecData,BPregisterParLow);
    % Convert to BP
    %BPlowFilterData = (BPlowFilterData-mean(BPlowFilterData))*(20/mean(BPlowFilterData));

    BPlowFilterDataCal = (BPlowFilterData-averagePressureDataPerSecond)*(20/averagePressureDataPerSecond);
    averagePressureDataPerSecond = mean(BPlowFilterData);
    BPData = [BPlowFilterDataCal.^1,BPlowFilterDataCal.^0]*BPCoeff';
    BPData = BPData(5:5:end);

    BP_ProcData(1:(sectionDataLen-fs)/5) = BP_ProcData(fs/5+1:end);
    BP_ProcData(end-fs/5+1:end) =  BPData;        


    % CALCULATE SYS
    total = 0;
    validCount = 0;
    [BP_PEAKS] = findPeakFunc(BP_ProcData,7, 0.3);        
    if BP_PEAKS.Num > 0            
        for i =1:BP_PEAKS.Num
            if ((BP_PEAKS.Mag(i) >= 80) && (BP_PEAKS.Mag(i)<= 180))
                total = total + BP_PEAKS.Mag(i);
                validCount = validCount + 1;
            end
        end
    end

    if validCount > 0   
        averagePeakBPPerSec = total / validCount;
        averagePeakBPSum = averagePeakBPSum + averagePeakBPPerSec;
        validPeakBPCount = validPeakBPCount + 1;        
    end


    %CALCULATE DIAS
    total = 0;
    validCount = 0;
    [BP_VALLEYS] = FindValleysFunc(BP_ProcData, 7, 0.8);
    if BP_VALLEYS.Num > 0
        for i =1:BP_VALLEYS.Num
            if ((BP_VALLEYS.Mag(i) >= 50) && (BP_VALLEYS.Mag(i) <= 140))
                total = total + BP_VALLEYS.Mag(i);
                validCount = validCount + 1;
            end
        end
    end

    if validCount > 0   
        averageValleyBPPerSec = total / validCount;
        averageValleyBPSum = averageValleyBPSum + averageValleyBPPerSec;
        validValleyBPCount = validValleyBPCount + 1;
    end
end

