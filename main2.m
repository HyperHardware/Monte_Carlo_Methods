clc; clear;
n = 30;
func = @(x,y)sin(x)*sin(y);
st = tic();
ret = dopp_Avg_corr_comp(func, 0, pi, 0, pi, n);
t = toc(st);
disp(ret);
disp(t);