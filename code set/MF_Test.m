N = 4096;
Y = signalFiltered(1:400);
M = length(Y);
fs = 125;
lambda = 0.1;
Phi = zeros(M,N);
for m = 1:M
    for n = 1:N
        Phi(m,n) = exp(j*(2*pi*m*n/N));
    end
end
f_HR = 1.2;
Nf = (f_HR*N)/fs +1;


% for it = 1:5
% 
%     [X_focuss, gamma_ind_focuss, gamma_est_focuss, count_focuss] = MFOCUSS(Phi, Y, lambda);
%     fprintf('%d: Times Finished \n',it);
%     
% end

[X_focuss] = OrigFocuss(Y,Phi,5) ;
X_focuss = abs(X_focuss);
binwidth = fs/N;
f=[0:binwidth:fs-binwidth];
plot(f(1:N/2),X_focuss(1:N/2));
title('SSR Results')
ylabel('Amplitute')
xlabel('Frequency (Hz)')