function [res_signal] = MoveBSL(signal,xaxis)
AC_Pressure = signal;
t8 = xaxis;
opol = 10;
[p,s1,mu] = polyfit(t8,AC_Pressure',opol); %
f_y = polyval(p,t8,[],mu);   %
a4osscilwave=AC_Pressure'-f_y;
figure(3);
plot(t8,a4osscilwave);
title(' Oscillometric waveform','FontWeight','bold','FontSize',20)
ylabel('Pressure ( mmHg )','FontWeight','bold','FontSize',16)
xlabel('second','FontWeight','bold','FontSize',20)
res_signal =  a4osscilwave;
end

