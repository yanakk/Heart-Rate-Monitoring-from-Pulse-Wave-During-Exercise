function [fs, mf] = WeiVerFreqSA(signal,pri,delta,sr)
xxx = signal;
s = length(xxx);
xfft = fft(xxx); % FFT
xfft_mag = abs(xfft); % take abs to return the magnitude of the frequency components
hpts = s/2; % half of the number points in FFT
xfft_mag_scaled = xfft_mag/hpts; % scale FFT result by half of the number of points used in the FFT

srate = sr;
binwidth = srate/s; % 125/70 Hz sample rate/  points in FFT
f=[0:binwidth:srate-binwidth]; % frequency scale goes from 0 to sample rate.Since we are counting from zero, we subtract off one binwidth to get the correct number of points

%plot first half of data
figure(10)
plot(f(1:hpts),xfft_mag_scaled(1:hpts));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Single-Sided Amplitude Spectrum');
xlim([0 10]);

mf = [];
Lm = ((pri-delta)/60/binwidth)+1; Rm =((pri+delta)/60/binwidth)+1;
range = xfft_mag_scaled(Lm:Rm);
[m,index] = max(range);

k = find(range>m/2,5);
weight = [];
iindex =[];
for i = 1:length(k)
    weight(end+1) = range(k(i))/m;
end
for i = 1:length(k)
    iindex(end+1) = (k(i)-1+Lm-1)*binwidth *weight(i);
end
mf(end+1) = sum(iindex) / sum(weight);
% 
% mf(end+1) = (index-1+Lm-1)*binwidth;

fs = xfft_mag_scaled(1:hpts);
% disp(mf)
end
