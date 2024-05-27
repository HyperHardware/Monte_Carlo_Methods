m = java.util.HashMap;
func = @(x,y) x+y;
m.merge("1,1", 114, ((a, b)->a+b));
m.merge("2,2", 514);


disp(m);