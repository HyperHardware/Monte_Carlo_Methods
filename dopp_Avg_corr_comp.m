% charset UTF-8
% 二维函数的改进平均值法复合
function [II_, clock_v] = dopp_Avg_corr_comp(tfunc, a, b, c, d, n, alpha)
    st = tic;
    if nargin < 7
        alpha = 0.05;
    end
    A = (b-a)*(d-c);
    g = 1/A;
    if alpha*g > 1
        str = ['传入的参数过大！目前的g=', num2str(g), ',你应当使得传入的alpha小于', num2str(A), '.'];
        ME = MException('arg:out', str);
        throw(ME);
    end
    h1 = (b-a)/n;  h2 = (d-c)/n;
    x = zeros(n+1,1); y = zeros(n+1,1);
    for k = 0:n
        x(k+1) = a+k*h1;
        y(k+1) = c+k*h2;
    end
    II_ = 0;
    for i = 1: n
        for j = 1:n
            
            zarr = rand(n*n, 1);
            ListX = java.util.LinkedList;
            ListY = java.util.LinkedList;
            borderX1 = x(i); borderX2 = x(i+1);
            borderY1 = y(i); borderY2 = y(i+1);
            for ii = 1:n
                for jj = i:n
                    xx =  rand(1,1)*(borderX2- borderX1) + borderX1; 
                    yy =  rand(1,1)*(borderY2- borderY1) + borderY1;
                    if tfunc(xx, yy)* alpha >= g*zarr(index1(ii, jj, n))
                        ListX.add(int64(ii));
                        ListY.add(int64(jj));
                    end
                end
            end
            count = ListX.size();
            tmp = 0;
            for k = 1:count
                tmp = tmp + tfunc(x(ListX.get(k-1)), y(ListY.get(k-1)));
            end
            if count ~= 0
                II_ = II_ + ((b-a)/n * (d-c)/n)/count*tmp;
            end
        end
    end
    clock_v = toc(st);
end