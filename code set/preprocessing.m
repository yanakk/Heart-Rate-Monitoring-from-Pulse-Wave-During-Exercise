sprate = 115;

AC_Pressure = allDataMatrix(:,3);
t8=0:1/sprate:(length(AC_Pressure)-1)/sprate;
F = load('lowpassF.mat');

[b,a]=sos2tf(F.SOS,F.G);
AC_Pressure = filter(b, a, AC_Pressure);
[res_signal] = MoveBSL(AC_Pressure,t8);
% qvr_signal = baseline(AC_Pressure,20);

subplot(4, 1, 1);
plot(allDataMatrix(:,3));
title('Raw Signal','FontWeight','bold','FontSize',16);
subplot(4, 1, 2);
plot(AC_Pressure);
title('Filtered Signal','FontWeight','bold','FontSize',16);
subplot(4, 1, 3);
plot(res_signal);
title('Polyfit-Processed Signal','FontWeight','bold','FontSize',16);
res_signal = res_signal(100:end);
subplot(4, 1, 4);
plot(qvr_signal);
title('QVR-Processed Signal','FontWeight','bold','FontSize',16);
