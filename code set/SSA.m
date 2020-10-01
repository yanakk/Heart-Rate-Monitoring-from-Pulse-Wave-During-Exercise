function [signalFiltered]=SSA(signal,windowLen,Lc,Rc)

% Step1 : Embedding
N=length(signal);
if windowLen>N/2
    windowLen=N-windowLen;
end
K=N-windowLen+1;
X=zeros(windowLen,K);
for i=1:K
    X(1:windowLen,i)=signal(i:windowLen+i-1);
end
% Step 2: Decomposition - SVD
% S=X*X';
% [U,autoval]=eig(S);
% [d,i]=sort(diag(autoval),'descend');
% sev=sum(d);
% U=U(:,i);
% V=(X')*U;
[U,S,V] = svd(X);   % X:m*n U:m*m   V:n*n   S:m*n

% Step 3: Grouping
I=[Lc:Rc]; 
Vt=V';
rca=U(:,I)*Vt(I,:);     %

% Step 4: Reconstruction
y=zeros(N,1);
Lp=min(windowLen,K);
Kp=max(windowLen,K);

% 1~Lp-1
for k=0:Lp-2
    for m=1:k+1
        y(k+1)=y(k+1)+(1/(k+1))*rca(m,k-m+2);
    end
end
% Lp~Kp
for k=Lp-1:Kp-1
    for m=1:Lp
        y(k+1)=y(k+1)+(1/(Lp))*rca(m,k-m+2);
    end
end
% Kp+1~N
for k=Kp:N-1
    for m=k-Kp+2:N-Kp+1
        y(k+1)=y(k+1)+(1/(N-k))*rca(m,k-m+2);
    end
end
 
signalFiltered = y;
end
