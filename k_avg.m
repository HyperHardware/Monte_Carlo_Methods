function [III, var] = k_avg(func, k, difArr, n)
    A = 1;
    for i = 1 : k
        A = A*(difArr(i,2)-difArr(i,1));
    end
    argarr = zeros(n, k);
    for i = 1:n
        for j = 1:k
            argarr(i, j) = rand()*(difArr(j,2)-difArr(j,1))+difArr(j,1);
        end
    end
    var = argarr;
    sum = 0;
    for i = 1:n
        sum = sum + func(argarr(i,:), k);
    end
    III = sum*A/(n);
end