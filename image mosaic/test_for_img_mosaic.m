imga = imread('tree1.png');%uttower1.jpg
imgb = imread('tree2.png');%uttower2.jpg

[points_a, points_b] = get_correspondences(imga , imgb);

H = homography_matrix(points_a, points_b);

[outputImage, x, y] = Warping(H, imga);

mergedImage = output_mosaic(imgb, outputImage, x, y);

figure;
imshow(mergedImage);