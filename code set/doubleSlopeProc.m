function [outputData,registerWin] = doubleSlopeProc(inputData,fs,registerWin)

% ˫б�ʴ���
%%for 125Hz
a = round(0.05*fs);  % ����Ŀ������0.015~0.060s;
b = round(0.1*fs);

%a = round(0.025*fs);  % ����Ŀ������0.015~0.060s;
%b = round(0.080*fs);

if isempty(registerWin)
    data = [zeros(2*b,1);inputData];
else
    data = [registerWin;inputData];
end
Ns = length(data) - 2*b;           % ȷ���ڲ������źų��ȣ�
registerWin = inputData(end-2*b+1:end);

S_l = zeros(1,b-a+1);
S_r = zeros(1,b-a+1);
S_dmax = zeros(1,Ns);
for i = 1:Ns          % ��ÿ����˫б�ʴ���
    for k = a:b
        S_l(k-a+1) = (data(i+b)-data(i+b-k))./k;
        S_r(k-a+1) = (data(i+b)-data(i+b+k))./k;
    end
    S_lmax = max(S_l);
    S_lmin = min(S_l);
    S_rmax = max(S_r);
    S_rmin = min(S_r);
    C1 = S_rmax-S_lmin;
    C2 = S_lmax-S_rmin;
    S_dmax(i) = mean([C1 C2]);
end
outputData = S_dmax;


