% charset UTF-8
% 改进的k维平均值法
function [III_, clock_v, args] = k_avg_corr(tfunc, intervals, n, alpha)

    st = tic;
    ParamLen = length(intervals(:,1));
    
    if ParamLen < 1
        throw MException('array:length', '参数长度不能为0或更少');
    end
    A = 1;
    for i = 1:ParamLen
        A = A * (intervals(i,2) - intervals(i,1));
    end
    g = 1/A;
    if nargin < 7
        alpha = A;
    end
    if alpha*g > 1
        str = ['传入的参数过大！目前的g=', num2str(g), ',你应当使得传入的alpha小于', num2str(A), '.'];
        ME = MException('arg:out', str);
        throw(ME);
    end
    m = 0;
    z = sort(rand(n, 1));
    III_ = 0; 
    args = zeros(1, ParamLen);
    for i = 1:n
        param = zeros(ParamLen, 1);
        for j = 1:ParamLen
            param(j) = rand()*(intervals(j,2)-intervals(j,1))+intervals(j,1);
        end
        if (alpha*g>=z(i))  
            m = m + 1;        
            args(m, :) = param;            
            III_ = III_ + tfunc(param, ParamLen);
        end
    end
    III_ = III_*A / m;
    clock_v = toc(st);
end