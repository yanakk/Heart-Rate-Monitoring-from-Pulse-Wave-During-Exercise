function [FocussResult] = OrigFocuss(y,A,iteration) 
% ######################################################################### 
% FOCal Underdetermined System Solver(FOCUSS) 
% [x] = OrigFocuss(y,A,iteration) solves underdetermined system y=Ax where  
% A is a matrix of dimensions [N by Ns], y is an observation vector [N by 
% 1],and x is an estimation vector of source signals [Ns by 1]. 
%  
% This function is only for single snapshot case, meaning the ovservation y 
% is just a column vector, not a matrix. 
%  
% Notation: > N: number of sensors, 
%           > Ns: number of sources, 
%           > A: observation matrix, 
%           > iteration: number of iterations. 
%  
% Author: MaZeqiang 
% Company: Tsinghua University, Beijing, PRC 
% Date: 2012-12-5 
% ######################################################################### 
%% 
disp('OrigFocuss function beigng called') ; 
fprintf('----------------------------------\n') ; 
 
if nargin ~= 3 
    disp('Incorrect number of input arguments') ; 
    return ; 
end 
 
[N M] = size(y) ; 
[K Ns] = size(A) ; 
if M ~= 1 
    disp('input arguments dimensions must agree') ; 
    return ; 
end 
 
if N~= K 
    disp('input arguments dimensions must agree') ; 
    return ; 
end 
     
if N>=Ns 
    disp('warning: A may not be an underdetermined matrix') ; 
end 
 
disp('iteration      normdiff') ; 
%% 
p = 0.8 ;   % weighted p norm minimization, p=0.8 is the best experimental  
% value, accordding to a series of papers. 
 
x = pinv(A)*y ; 
epsino = 1e-3 ; 
for k=1:iteration 
    xold = x ; 
    W = diag(x) ; 
    W = W.^(1-p/2) ; 
    x = W*pinv(A*W)*y ; 
    normdiff = norm(x,2)-norm(xold,2) ; %  
    fprintf('  %d',k) ; 
    fprintf(':           ') ; 
    fprintf('%f\n',normdiff) ;     
end 
FocussResult = x ; 
 
if normdiff<=epsino 
    fprintf('FOCUSS Status: Solved\n') ; 
else 
    fprintf('FOCUSS Status: Unsolved\n') ; 
end 
 
fprintf('----------------------------------\n') ; 
end