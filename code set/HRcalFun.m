function [HR,MeanHR,A] = HRcalFun(data)
xx = data;
Fs = 125;   % sample rate 125
% interval = 0.008;   % 1/125
interval = 1/125;

initial_check = int32(0.48/interval);
% HR = 60;
% move = 60.0/(0.008*0.2*HR);
Len = length(xx);
check = initial_check;
A = [];
Raw_HR = [];
MeanHR = [];
Smooth_HR = [];
HR = [];
rate = 0.3;         % can change the rate of floating
mov_cof = 2.5;
max_change = 15;
pt = initial_check;

% Update range by the previous HR
for i = 1:(Len - 2*initial_check)
   pt = pt + 1;         % move
   if pt + check > Len
       break
   end
   
   temp = xx(pt-check:pt+check);    % search in the specific field
   maxx = max(temp);
   
   if maxx == xx(pt)    % if the point is the max in the field
       A(end+1) = pt;
%        pt = pt + mov_cof*check;
       if length(A)>1
           dn = A(end)-A(end-1);
           Raw_HR(end+1) = 60.0/(dn*interval);
           
           if length(Raw_HR)>1 && abs(Raw_HR(end) - Raw_HR(end-1)) < max_change
               HR(end+1) = Raw_HR(end);
               MeanHR(end+1) = mean(HR);    % OR mean(Raw_HR)
               check = int32(rate*60/(interval*MeanHR(end)));   % change the check, KEY POINT!!!! MODIFY HERE   HR OR MEANHR
           end
       end
       
       if check == initial_check
           pt = pt + check;
       else
           pt = pt + mov_cof*check;
       end
       
       if length(A)>4
           dn = A(end)-A(end-4);
           temp = 240.0/(dn*interval);
           if isempty(Smooth_HR)
               Smooth_HR(end+1) = temp;
           elseif abs(temp-Smooth_HR(end)) < 10 && temp > 55
               Smooth_HR(end+1) = temp;
           elseif temp-Smooth_HR(end)>0
               Smooth_HR(end+1) = Smooth_HR(end)+1;
           elseif temp-Smooth_HR(end)<0
               Smooth_HR(end+1) = Smooth_HR(end)-1;
           end

       end
       
   end
end
% plot(Smooth_HR)
HR = Smooth_HR; % or Smooth_HR
end

