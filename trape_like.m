% charset UTF-8
% 一维函数的梯形平均值法
function ret = trape_like(tfunc, a, b, n)
    varArr = rand(2*n,1);
    varArr = sort(varArr);
    
    varetaArr = zeros(2*n,1);
    for i = 1:2*n
        varetaArr(i) = a + (b-a)/(2*n)*(i-1+varArr(i));
    end
    varfuncArr = zeros(n, 1);
    for i = 1:n
        varfuncArr(i) = (tfunc(varetaArr(2*i-1)) + tfunc(varetaArr(2*i)) )/2;
    end
    I__ = (b-a)*MyAlgorithms.avg(varfuncArr);
    ret = I__;
end