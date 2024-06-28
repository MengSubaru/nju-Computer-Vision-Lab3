imga = imread('to_insert_img.png');
imgb = imread('dest_frame.png');

[points_a, points_b] = get_correspondences(imga , imgb);

H = homography_matrix(points_a, points_b);

start_x = floor(min(points_b(:, 1)));
start_y = floor(min(points_b(:, 2)));
end_x = ceil(max(points_b(:, 1)));
end_y = ceil(max(points_b(:, 2)));

w2 = end_x - start_x + 1;
h2 = end_y - start_y + 1;

[X, Y] = meshgrid(start_x:end_x, start_y:end_y);

transformed = ones(3, h2*w2);
transformed(1, :) = reshape(X, 1, h2*w2);
transformed(2, :) = reshape(Y, 1, h2*w2);

before_transform = H \ transformed;
before_transform = before_transform ./ before_transform(3, :);

x_correspondence = reshape(before_transform(1, :), h2, w2);%h*w
y_correspondence = reshape(before_transform(2, :), h2, w2);%h*w

outputImage = zeros(h2, w2, 3);
for i = 1 : 3      
    outputImage(:, :, i) = interp2(double(imga(:, :, i)), x_correspondence, y_correspondence);
end

imgb(start_y:end_y, start_x:end_x, :) = outputImage;

figure;
imshow(imgb);