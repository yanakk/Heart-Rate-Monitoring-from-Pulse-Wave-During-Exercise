
%function [a] = wave_r(path)

clear all;
sprate =125; %input('\n Input the Sampleing Frequency:  ');
T=10;
path='D:\yhy\study\课程\短学期20夏\research\yhydata\脚部运动\2020-07-23_194136';
q=[path,'.ch2' ];
% ch0-ch4
%------ch0------
fid=fopen([path,'.ch0' ],'rb');
file=fread(fid,'uint16');
fclose(fid);
a=file;
Ch0=a';
for i=1:length(Ch0)
   if Ch0(i)<2071
     P0(i)=0.011*Ch0(i) - 3.591;
   elseif Ch0(i)<4350
     P0(i)=0.030*Ch0(i) - 47.62;
   else
     P0(i)=0.082*Ch0(i) - 276.3;       
   end
     
end


%-------弄ch1------
fid=fopen([path,'.ch1' ],'rb');
file=fread(fid,'uint16');
fclose(fid);
a=file;
Ch1=a';
for i=1:length(Ch1)
   if Ch1(i)<2071
     P1(i)=0.011*Ch1(i) - 3.591;
   elseif Ch0(i)<4350
     P1(i)=0.030*Ch1(i) - 47.62;
   else
     P1(i)=0.082*Ch1(i) - 276.3;       
   end
     
end
%-------ch2------
fid=fopen([path,'.ch2' ],'rb');
file=fread(fid,'uint16');
fclose(fid);
a=file;
Ch2=a';
for i=1:length(Ch0)
   if Ch2(i)<2071
     P2(i)=0.011*Ch2(i) - 3.591;
   elseif Ch0(i)<4350
     P2(i)=0.030*Ch2(i) - 47.62;
   else
     P2(i)=0.082*Ch2(i) - 276.3;       
   end
     
end
%-------ch3------
fid=fopen([path,'.ch3' ],'rb');
file=fread(fid,'uint16');
fclose(fid);
a=file;
Ch3=a';
for i=1:length(Ch0)
   if Ch3(i)<2071
     P3(i)=0.011*Ch3(i) - 3.591;
   elseif Ch0(i)<4350
     P3(i)=0.030*Ch3(i) - 47.62;
   else
     P3(i)=0.082*Ch3(i) - 276.3;       
   end
     
end

%-------ch4------
fid=fopen([path,'.ch4' ],'rb');
file=fread(fid,'uint16');
fclose(fid);
a=file;
Ch4=a';
for i=1:length(Ch0)
   if Ch4(i)<2071
     P4(i)=0.011*Ch4(i) - 3.591;
   elseif Ch0(i)<4350
     P4(i)=0.030*Ch4(i) - 47.62;
   else
     P4(i)=0.082*Ch4(i) - 276.3;       
   end
     
end
%-------------------
MinFileLength=min([length(Ch0) length(Ch1) length(Ch2) length(Ch3) length(Ch4)]);
t=0:1/sprate:(MinFileLength-1)/sprate;
%Array5Data=[Ch0(1:MinFileLength)' Ch1(1:MinFileLength)' Ch2(1:MinFileLength)' Ch3(1:MinFileLength)' Ch4(1:MinFileLength)'];
Array5Data=[P0(1:MinFileLength)' P1(1:MinFileLength)' P2(1:MinFileLength)' P3(1:MinFileLength)' P4(1:MinFileLength)'];
figure(1);
plot(t,Array5Data,'DisplayName','Array5Data');
title('Sensor raw data','FontWeight','bold','FontSize',18)
ylabel('Pressure (mmHg)','FontWeight','bold','FontSize',16)
xlabel('Second','FontWeight','bold','FontSize',16)

drift = 1;
AC_Pressure=P3(drift:end)';
t8=0:1/sprate:(length(AC_Pressure)-1)/sprate;

% [res_signal] = MoveBSL(AC_Pressure,t8);
res_signal = AC_Pressure;

% %aq=a(1:T*sprate+1);
% %--------------------plot time domain figure (16 bits ADC)--------------------------
% %aa=90+(a(1:T*sprate+1)-mean(a(1:T*sprate+1)))*3.3*51.749326/65536/6  ;
% subplot(2, 1, 1);
% plot(t8,res_signal);   
% %title('Pulse wave derived from the transducer of TD01C-1')
% title('Ionic sensor pressure - stand','FontWeight','bold','FontSize',18)
% % ylabel('Pressure (mmHg)','FontWeight','bold','FontSize',16)
% xlabel('Second','FontWeight','bold','FontSize',16)
% xlim([0 100])
% subplot(2, 1, 2);
% tv=0:1/fs:(length(data)-1)/fs;
% plot(tv,data)
% xlim([0 100])
% title('Sound track','FontWeight','bold','FontSize',18)
% xlabel('Second','FontWeight','bold','FontSize',16)

F = load('lowpassF.mat');
[b,a]=sos2tf(F.SOS,F.G);
res_signal = filter(b, a, res_signal);
figure(2);
plot(t,res_signal,'DisplayName','Array5Data');
title('Selected Channel data','FontWeight','bold','FontSize',18)
ylabel('Pressure (mmHg)','FontWeight','bold','FontSize',16)
xlabel('Second','FontWeight','bold','FontSize',16)
