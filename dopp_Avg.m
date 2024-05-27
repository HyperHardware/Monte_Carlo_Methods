% charset UTF-8
% 二维函数的原始平均值法
function [II_, x, y] = dopp_Avg(tfunc, a, b, c, d, n)
    A = ((b-a)*(d-c));
    g = 1/A;
    x  =  a+(b-a)*rand(n,1);
    y  =  c+(d-c)*rand(n,1);
    add = 0;
    for i = 1:n
        add = add + tfunc(x(i), y(i));
    end
    II_ = A/n*add;
end
