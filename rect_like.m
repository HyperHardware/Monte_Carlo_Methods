% charset UTF-8
% 一维函数的矩形平均值法
function ret = rect_like(tfunc, a, b, n)
    varArr = a + (b-a)*rand(n,1);
    varArr = sort(varArr);
    varetaArr = zeros(n,1);
    for i = 1:n
        varetaArr(i) = a + (b-a)/n*(varArr(i)+i-1);
    end
    I_ = (b-a)*MyAlgorithms.avg(tfunc(varetaArr));
    ret = I_;
    
end