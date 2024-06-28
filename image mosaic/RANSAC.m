function H = RANSAC (points_a, points_b)
    %points_a,b为经过算法初始选出的匹配点集，其中存在噪声点

    H = []; %作为结果的单应性矩阵
    matches_points = 0; %内点最多的单应性矩阵计算出的内点数目

    num = size(points_a, 1);

    src_points = ones(3, num);
    src_points(1, :) = points_a(:, 1);
    src_points(2, :) = points_a(:, 2);

    idx = randperm(num, 25); %初始随机选取若干个内点

    a = points_a(idx, :);
    b = points_b(idx, :);

    for i = 1 : 10 %最大迭代次数需要根据情况选择

        tmp_H = homography_matrix(a, b); %由当前内点计算出的H

        tar_points = tmp_H * src_points;
        tar_points = permute(tar_points(1:2, :), [2, 1]);

        res = tar_points - points_b;
        res = res .* res;
        dis = sqrt(res(:, 1) + res(:, 2));

        logical_vector = dis < 30; %用于界定内点的threshold

        a = points_a(logical_vector, :);
        b = points_b(logical_vector, :);

        if size(a, 1) > matches_points
            H = tmp_H;
            matches_points = size(a, 1);
        end

    end
    
end