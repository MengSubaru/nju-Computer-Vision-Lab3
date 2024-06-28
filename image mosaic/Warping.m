function [outputImage, start_x, start_y] = Warping(H, inputImage)
    %outputImage为处理后的图像，(start_x, start_y)代表这幅图像的左上角在目标图像坐标系下的坐标
    h = size(inputImage, 1);
    w = size(inputImage, 2);
    
    [x, y] = meshgrid(1:w, 1:h);
    
    before_transform = ones(3, h*w);
    before_transform(1, :) = reshape(x, 1, h*w);
    before_transform(2, :) = reshape(y, 1, h*w);

    transformed = H * before_transform;% 3*3 * 3*(h*w)
    transformed = transformed ./ transformed(3, :);
    
    start_x = floor(min(transformed(1, :)));
    start_y = floor(min(transformed(2, :)));
    end_x = ceil(max(transformed(1, :)));
    end_y = ceil(max(transformed(2, :)));

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
        outputImage(:, :, i) = interp2(double(inputImage(:, :, i)), x_correspondence, y_correspondence);
    end
    
    outputImage(isnan(outputImage)) = 0;
    outputImage = uint8(outputImage);
end