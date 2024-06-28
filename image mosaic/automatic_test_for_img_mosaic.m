%使用此脚本之前请仿照第二行的格式配置vlfeat库的相关信息以确保可以找到相关函数
%run('../vlfeat-0.9.21/toolbox/vl_setup.m');

imga = imread('uttower1.jpg');% tree1.png
imgb = imread('uttower2.jpg');% tree2.png

img1 = single(rgb2gray(imga));
img2 = single(rgb2gray(imgb));

[f1, d1] = vl_sift(img1);
[f2, d2] = vl_sift(img2);
matches= vl_ubcmatch(d1, d2, 10.0);% 测试RANSAC算法请将此处的10.0更换为4.0
%第三个参数THRESH的选择会影响效率和结果，THRESH越大越快，选择的对应点越少；THRESH越小越慢，选择的对应点越多但是错误匹配的点对也会增加

points_a = zeros(size(matches, 2), 2);
points_a(:, 1) = f1(1, matches(1, :));
points_a(:, 2) = f1(2, matches(1, :));

points_b = zeros(size(matches, 2), 2);
points_b(:, 1) = f2(1, matches(2, :));
points_b(:, 2) = f2(2, matches(2, :));

% 选用RANSAC筛除噪声点请选择使用RANSAC计算单应性矩阵，否则请调用homography_matrix计算单应性矩阵
%H = RANSAC(points_a, points_b);
H = homography_matrix(points_a, points_b);

[outputImage, x, y] = Warping(H, imga);

mergedImage = output_mosaic(imgb, outputImage, x, y);

figure;
imshow(mergedImage);