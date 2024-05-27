% charset UTF-8
% 二重积分的改进平均值法
function [II_, clock_v, Vararr] = dopp_Avg_corr(tfunc, a, b, c, d, n, alpha)
    
    st = tic;
    A = (b-a)*(d-c);
    g = 1/A;
    if nargin < 7
        alpha = A;
    end
    if alpha*g > 1
        str = ['传入的参数过大！目前的g=', num2str(g), ',你应当使得传入的alpha小于', num2str(A), '.'];
        ME = MException('arg:out', str);
        throw(ME);
    end
    Vararr.xarr = zeros(n,1);
    Vararr.yarr = zeros(n,1);
    m = 0;
    z = sort(rand(n, 1));
    II_ = 0;
    for i = 1:n
        x = rand()*(b-a)+a;
        y = rand()*(d-c)+c;
        if alpha*g >= z(i)
            m = m + 1;
            Vararr.xarr(m) = x;
            Vararr.yarr(m) = y;      
            II_ = II_ + tfunc(x, y);
        end
    end
    II_ = II_* A / m;
    clock_v = toc(st);
end