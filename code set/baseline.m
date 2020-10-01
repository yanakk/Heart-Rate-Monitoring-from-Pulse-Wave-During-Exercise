function outdata=baseline(indata,theta)
[r,c] = size(indata);
s = 0;
if r < c
    indata = indata';
    r1 = r;
    r = c;
    c = r1;
    s = 1;
end
outdata = zeros(r,c);
for i = 1:c
   cdata = indata(:,i); 
   D = zeros(r-1, r); 
   for j = 1:r-1
       D(j,j) = 1;
       D(j,j+1) = -1;
   end
   z = (eye(r,r) - inv(eye(r,r) + theta * D' * D)) * cdata;
   outdata(:,i) = z;
end
if s == 1
    outdata = outdata';
end