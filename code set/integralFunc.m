function [integralData,intRegister] = integralFunc(inputData,intLen,intRegister)

if isempty(intRegister)%initial
    intRegister = zeros(1,intLen-1);
end

data = [intRegister, inputData];
intRegister =  inputData(end-intLen+2:end);
for k = intLen:length(data)
    integralData(k-intLen+1) = sum(data(k-intLen+1:k));
end
