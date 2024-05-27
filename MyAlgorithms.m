% File charset: UTF-8
classdef MyAlgorithms % namespace MyAlgrorithms一些实用的计算函数
    methods(Static)
        % AVG 用于求取一个数组的平均值 返回平均值
        function ret = avg(Array)
        
            lg = length(Array);
            ret = 0;
            if lg < 1
                ME = MException('array:index', '传入的数组长度为%d小于等于1。',lg);
                throw(ME);
                
            end
            for i = 1:lg
                ret = ret + Array(i);
            end
            ret = ret / lg;
        end % end avg
        
        % 二维坐标组的随机性检验 返回是否符合分布的布尔值
        function [flag, clock_v] = randomization_test_2(Xarr, Yarr, a, b, c, d, m, alpha)
            t0 = tic;
            if nargin < 8
                alpha = 0.05;
            end
            lg = length(Xarr); lgt = length(Yarr);
            if lg ~= lgt
                ME=MException('array:length', 'X向量长度%d和Y向量长度%d并不一致', lg, lgt);
                throw(ME);
            end
            % countArr = zeros(m, m);
            

            % 针对XYarr的坐标点确定法
            h1 = (b-a)/m; h2 = (d-c)/m;
            HMap = java.util.HashMap; % 我直接用java的Hashmap！
            
            
            for ii = 1:lg
                
                keyX = fix(Xarr(ii)/h1); keyY = fix(Yarr(ii)/h2);
                keystr = [num2str(keyX),',',num2str(keyY)];
                % 使用java的hashmap生成唯一的键值对
                % hashmap是java官方的容器 应该相信它的效率
                if (HMap.containsKey(keystr)) 
                    HMap.put(keystr, int64(HMap.get(keystr)+1));
                else
                    HMap.put(keystr, int64(1));
                end
            end
            V = 0; n = lg;
            % for i = 1:m
            %     for j = 1:m
            %         V = V + ( countArr(i,j) - n/(m*m) )^2;
            %     end
            % end
            valSet = HMap.values();
            setIter = valSet.iterator();
            while setIter.hasNext()
                V = V + (setIter.next() - n/(m*m) )^2;
            end
            V = V + (m*m-valSet.size())*(n/(m*m))^2;
            % χ²检验统计量计算
            V = V*m*m/n;
            flag = (V < chi2inv(1-alpha, m*m-1));
            clock_v = toc(t0);
            
        end % end homogeneity_test
        
        % 二维坐标组的独立性检验 返回布尔值
        function [flag, clock_v] = independence_test_2(Xarr, Yarr, alpha)
            t0 = tic;
            if nargin < 3
                alpha = 0.05;
            end
            N = length(Xarr); Nt = length(Yarr);
            if N ~= Nt
                ME = MException('array:length', 'X向量长度%d和Y向量长度%d并不一致。', N, Nt);
                throw(ME);
            end
            % 正文
            miu_r = N/2;  sig_r = sqrt(N)/2;
            popv = norminv(1-alpha/2, 0, 1); % 正态分布在α/2处的分位值
            domain_r = miu_r + popv*sig_r;
            domain_l = miu_r - popv*sig_r; % 接受域左右端点

            Norm1Arr = zeros(N,1);  % 1范数序列
            z_ = 0;
            for i = 1:N
                % 一个问题
                % 教材上说的是||zi||₁ = xi + yi，但是一范数的定义实际上是||zi||₁ = |xi| + |yi|
                Norm1Arr(i) = abs(Xarr(i)) + abs(Yarr(i));
                z_ = z_ + Norm1Arr(i);
            end
            z_ = z_/N;
            zp_arr = zeros(N, 1);
            for i = 1:N
                if (Norm1Arr(i) < z_)
                    zp_arr(i) = -1;
                else
                    zp_arr(i) = 1;
                end
            end
            r = 0;
            for i = 1:N-1
                if zp_arr(i)*zp_arr(i+1) < 0
                    r = r+1;
                end
            end
            flag = (r >= domain_l)&&(r <= domain_r);
            clock_v = toc(t0);
        end % end independence_test2

        % k维坐标组的随机性检验 返回是否符合分布的布尔值
        function flag = randomization_test(VecArr, IntervalArr, m, alpha)
            if nargin < 4
                alpha = 0.05;
            end
            % 先进行检验 输入的参数是否合理
            Vecnum = length(VecArr(:,1));  % 向量个数
            Veclg = length(VecArr(1,:));   % 向量维数
            Veclg_test = length(IntervalArr(:,1));  Inv_p = length(IntervalArr(1,:));
            if Inv_p ~= 2
                throw(MException('array:interval', '输入的区间组不是合法的区间：必须要有两个端点。'));
            end
            if Vecnum < 1
                throw(MException('array:length', '传入的向量组的个数为%d', Vecnum));
            end
            if Veclg ~= Veclg_test
                throw(MException('array:length', '向量组向量的维数%d和区间维数%d并不相同', Veclg, Veclg_test));
            end
            
            % 正文
            % 稀疏矩阵，但是matlab没有链表 迫使我开辟这么大一块内存
            % 还是不开辟了
            % CountMat = zeros(m^Veclg, Veclg); 
            CountMat = [];
            Index = 1;
            % 锚定VecArr点的位置 用稀疏矩阵记录
            for i = 1:Vecnum
                j = 1;
                for j = 1:Veclg
                    Heft = VecArr(i,j);
                    Inetrval = IntervalArr(i,:);
                    Heft = Heft - Inetrval(1);
                    h = (Interval(2) - Inetrval(1))/m;
                    pos = round(Heft/h);
                    if pos < m && pos > 0
                        CountMat(Index, j) = pos;
                    else
                        break;
                    end
                end
                % 指针在尾部
                if j == Veclg
                    Index = Index + 1;
                else
                    CountMat(Index, :) = zeros(1, Veclg); %数据报废，直接清空
                end
            end
            % 稀疏矩阵统计节点
            Index = Index - 1;
            Index2 = 0;
            CountArr = zeros(Index, 1);
            CountMat = CountMat([1,Index],:);
            CountMattmp = CountMat;
            for i = 1:Index
                if arrEqual(CountMattmp(i,:), zeros(1,Veclg))
                    break;
                end
                Index2 = Index2+1;
                CountArr(Index2) = 1;
                for j = i:Index
                    if arrEqual(CountMattmp(i,:), CountMattmp(j,:))
                        CountMattmp(j,:) = zeros(1, Veclg);
                        CountArr(Index2) = CountArr(Index2) + 1;
                    end
                end
                
            end

            % 统计完毕 准备计算V
            V = 0; k = veclg;
            for i = 1 : Index2
                V = V + (CountArr(i)-n/(m^k))^2; 
            end
            V = n*(V + (n/(m^k))^2 * (m^k-index2))/M^k;
            flag = (V < chi2inv(1-alpha, m*m-1));

        end % end homogeneity_test

        % k维坐标组的独立性检验 返回布尔值
        function flag = independence_test(VecArr, alpha)
            if nargin < 3
                alpha = 0.05;
            end
            Vecnum = length(VecArr(:,1));
            if Vecnum < 1
                ME = MException('array:index', '传入向量组的向量数量为%d', Vecnum);
                throw(ME);
            end
            Veclg = length(VecArr(1,:));
            if Veclg < 1
                ME = MException('array:length', '传入向量组的每个向量长度为%d',Veclg);
                throw(ME);
            end
            N = Vecnum;
            miu_r = N/2;  sig_r = sqrt(N)/2;
            popv = norminv(1-alpha/2, 0, 1); % 正态分布在α/2处的分位值
            domain_r = miu_r + popv*sig_r;
            domain_l = miu_r - popv*sig_r; % 接受域左右端点

            Norm1Arr = zeros(N,1);  % 1范数序列
            for i = 1:N
                % 问题同上
                for j = 1:Veclg
                    Norm1Arr(i) = abs(VecArr(i,j));
                end
                z_ = z_ + Norm1Arr(i);
            end
            z_ = z_/N;
            zp_arr = zeros(N);
            for i = 1:N
                if (Norm1Arr(i) < z_)
                    zp_arr(i) = -1;
                else
                    zp_arr(i) = 1;
                end
            end
            r = 0;
            for i = 1:N-1
                if zp_arr(i)*zp_arr(i+1) < 0
                    r = r+1;
                end
            end
            flag = (r >= domain_l)&&(r <= domain_r);
        end % end independence_test

    end

    % 隐藏部分函数的实现
    methods(Static, Access = private)
        % 用来判断两个一维数组是否完全相等
        function ret = arrEqual(Arr1, Arr2)
            if length(Arr1) ~= length(Arr2)
                ret = false;
                return;
            end
            for i = 1:length(Arr1)
                if Arr1(i) ~= Arr2(i)
                    ret = false;
                    return;
                end
            end
            ret = true;
        end
    end
end