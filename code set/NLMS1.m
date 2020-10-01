% plot(allDataMatrix(1000:3000,:))
Len = length(Array5Data(1:end,:));

LF = load('lowpassF.mat');
[b,a]=sos2tf(LF.SOS,LF.G);
allDataMatrix = filter(b, a, Array5Data(1:end,:));
% F = load('lowpassF.mat');
% [b,a]=sos2tf(F.SOS,F.G);
% allDataMatrix = filter(b, a, allDataMatrix);

% x = allDataMatrix(:,4);
% v1 = allDataMatrix(:,3);    % CH3 as noise REF
x = allDataMatrix(:,4);
v1 = allDataMatrix(:,3);    % CH3 as noise REF

L = 7;
lms = dsp.LMSFilter(L,'Method','LMS');
nlms = dsp.LMSFilter(L,'Method','Normalized LMS'); % six order

% [ylms,elms,wlms] = lms(v1,x);
[ynlms,enlms,wnlms] = nlms(v1,x);

% enlms = filter(b, a, enlms);

n = (1:Len)';
plot(n,[x,v1,enlms])
legend('Raw data','Noise reference data','NLMS denoised')
xlabel('Time index (n)')
ylabel('Amplitude')
title('AF Results','FontWeight','bold','FontSize',18);

% hold on
% plot(n,x,'k:')
% xlabel('Time index (n)')
% ylabel('Amplitude')
% hold off
