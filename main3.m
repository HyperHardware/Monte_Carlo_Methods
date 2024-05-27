clc; clear;
n = 100000;
func = @(param, k) sin(param(1))*sin(param(2))*sin(param(3));
difarr = [0,pi;0,pi;0,pi];
% disp(difarr);
st = tic();
ret = k_avg_corr(func, difarr, n);
t = toc(st);
disp(ret)
disp(t)