function [ret, clock_v] = k_avg_corr_comp(tfunc, intervals, n, inputArg2)
    st = tic;
    paramlen = length(intervals);
    A = 1;
    for i = 1 : paramlen
        A = A * (intervals(i,2)-intervals(i,1));
    end
    g = 1/A;
    ii = 0; jj = 0;
    param=zeros(paramlen, 1);
    for i = 1 : n
        for ii = 1 : paramlen
            param(i) = rand()*(intervals())
        end
    end
    clock_v = toc(st);
end