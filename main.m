addpath("jsonlab/*");
% 在此运行测试
func = @(x) sin(x);
ret = original_Avg(func, -2, 2, 10000);
disp(ret);

func2 = @(x,y) exp(x+y);
format long
fprintf('原始函数f(x,y)=e^(x+y)\n');
fprintf('使用平均值法计算二重积分∬[-1,1]x[-1,1] f(x,y) dxdy\n');
[ret,x,y] = dopp_Avg(func2, 0,1,0,1,10000);
disp(ret);
fprintf('对生成的随机变量进行随机性检验(需要等待一段时间)\n');

ret2 = -1; clock_v = 0;
try
    [ret2, clock_v] = MyAlgorithms.randomization_test_2(x,y,0,1,0,1,10000);
catch ME
    disp(ME);
end

disp(ret2);
fprintf('耗时：%0.4f s\n', clock_v);
clock_v = 0;
fprintf('对生成的随机变量进行独立性检验\n');
ret3 = -1;
try
    [ret3, clock_v] = MyAlgorithms.independence_test_2(x,y);
catch ME
    disp(ME);
end
disp(ret3);
fprintf('耗时：%0.4f s\n', clock_v);

fprintf('原始函数f(x,y)=e^(x+y)\n');
fprintf('使用改进平均值法计算二重积分∬[-1,1]x[-1,1] f(x,y) dxdy\n');
ret = dopp_Avg_corr(func2, 0,1,0,1,10);
disp(ret);