count = 0;
% calculate HR in frequency domain
% xxx = allDataMatrix(:,3);
% xxx = res_signal;   % Raw
% xxx = qvr_signal;
% xxx = signalFiltered;
% xxx = int_signalFiltered;
xxx = integralData;
% xxx = qvr_signalFiltered;

s = length(xxx);
xfft = fft(xxx); % FFT
xfft_mag = abs(xfft); % take abs to return the magnitude of the frequency components
hpts = s/2; % half of the number points in FFT
xfft_mag_scaled = xfft_mag/hpts; % scale FFT result by half of the number of points used in the FFT

srate = 92;
binwidth = srate/s; % 125/70 Hz sample rate/  points in FFT
f=[0:binwidth:srate-binwidth]; % frequency scale goes from 0 to sample rate.Since we are counting from zero, we subtract off one binwidth to get the correct number of points

%plot first half of data
plot(f(1:hpts),xfft_mag_scaled(1:hpts));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Single-Sided Amplitude Spectrum');

FHR = [];
% s = length
WL = srate*10;
for i = WL+1:WL/10:s
%     [fs,mf] = FreqSA(xxx(i-WL:i));
    if isempty(FHR)
        [fs,mf] = WeiVerFreqSA(xxx(i-WL:i),100,12,srate);
    else
        [fs,mf] = WeiVerFreqSA(xxx(i-WL:i),FHR(end),12,srate);
    end

    plot(xxx(i-WL:i));
    R_FHR = mf*60;
%     disp(R_FHR);
    if isempty(FHR)    % if initial
        if R_FHR > 50 && R_FHR < 130
            FHR(end+1) = mf*60;
        end
    else
        if R_FHR > 50 && R_FHR < 160 && abs(R_FHR - FHR(end))<10
            FHR(end+1) = mf*60;
        elseif R_FHR - FHR(end) > 0
            FHR(end+1) = FHR(end)+1;  % stay same
            count = count+1;
        elseif R_FHR - FHR(end) < 0
            FHR(end+1) = FHR(end)-1;  % stay same
            count = count+1;
        end
        
    end
end
% [fs,mf] = FreqSA(xxx);
% FHR(end+1) = mf*60;
% disp(FHR);

plot(FHR);
hold on;
plot(bpmValue);
hold on;
% plot(bpmShoesMatrix);
plot(ECG_HR(10:end));
legend('SSA-FFT HR','SSA-Time HR','ECG')
xlabel('Second')
ylabel('BPM')
title('HR results comparison')
