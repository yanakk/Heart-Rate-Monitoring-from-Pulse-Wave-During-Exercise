function [fs, mf] = FreqSA(signal)
xxx = signal;
s = length(xxx);
xfft = fft(xxx); % FFT
xfft_mag = abs(xfft); % take abs to return the magnitude of the frequency components
hpts = s/2; % half of the number points in FFT
xfft_mag_scaled = xfft_mag/hpts; % scale FFT result by half of the number of points used in the FFT

srate = 125;
binwidth = srate/s; % 125 Hz sample rate/  points in FFT
f=[0:binwidth:srate-binwidth]; % frequency scale goes from 0 to sample rate.Since we are counting from zero, we subtract off one binwidth to get the correct number of points

%plot first half of data
figure(10)
plot(f(1:hpts),xfft_mag_scaled(1:hpts));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Single-Sided Amplitude Spectrum');
xlim([0 10]);

mf = [];
[m,index] = max(xfft_mag_scaled);
mf(end+1) = (index-1)*binwidth;

fs = xfft_mag_scaled(1:hpts);
% disp(mf)
end

