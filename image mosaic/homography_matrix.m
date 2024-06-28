function H = homography_matrix(points_a, points_b)
    %a、b均为n*2的矩阵，矩阵每一行对应一个点的(x,y)坐标，两个矩阵的同一行代表一对对应点
       
    n = size(points_a, 1);
    %至少四对点，可以更多，即n=size(points_a, 1)=size(points_b, 1)>=4
    A = zeros(2 * n, 8); 
    for i = 1 : n
        A(2*i-1:2*i, :) = createA(points_a(i, :), points_b(i, :));
    end

    b = zeros(2*n, 1);
    b(1 : 2 : end) = points_b(:, 1);
    b(2 : 2 : end) = points_b(:, 2);

    res_vector = A \ b;
    
    H = ones(3, 3);

    H(1, :) = res_vector(1:3, 1);
    H(2, :) = res_vector(4:6, 1);
    H(3, 1:2) = res_vector(7:8, 1);
end

function matrix = createA (a, b)
    %a，b应该为1*2的向量
    %结果必须为2*8的矩阵
    matrix = zeros(2, 8);

    matrix(1, 1 : 2) = a;
    matrix(1, 3) = 1;

    matrix(1 : 2, 7 : 8) = - (b') * a;

    matrix(2, 4 : 5) = b;
    matrix(2, 6) = 1;
end