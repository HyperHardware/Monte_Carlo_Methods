% Encoding UTF-8
% 一维函数的原始的平均值法

% 目标函数，左端点，右端点，抛分区间个数
function ret = original_Avg(tfunc, a, b, n )  
    varArr = a + (b-a)*rand(n,1);
    varArr = sort(varArr);
    funcvarArr = tfunc(varArr);
    I_ = (b-a)* MyAlgorithms.avg(funcvarArr);
    ret = I_;
end