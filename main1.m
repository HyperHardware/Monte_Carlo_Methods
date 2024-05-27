clc; clear;
n = 1000000;
func = @(x)sin(x);
st = tic();
ret = trape_like(func, 0, pi/2, n);
t = toc(st);
disp(ret)
disp(t)