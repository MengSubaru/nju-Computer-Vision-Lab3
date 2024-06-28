function mergedImage = output_mosaic(destImage, warpedSource, start_x, start_y)
    h1 = size(destImage, 1);
    h2 = size(warpedSource, 1);
    w1 = size(destImage, 2);
    w2 = size(warpedSource, 2);
    h = h1 + h2;
    w = w1 + w2;

    mergedImage = uint8(zeros(h, w, 3));

    if start_x < 1
        if start_y < 1%在左上角填充
            mergedImage(1:h2, 1:w2, :) = warpedSource;        
            mergedImage(2-start_y:1-start_y+h1, 2-start_x:1-start_x+w1, :) = destImage;      
        else%左和左下
            mergedImage(start_y:start_y+h2-1, 1:w2, :) = warpedSource;
            mergedImage(1:h1, 2-start_x:1-start_x+w1, :) = destImage;    
        end
    else%start_x >=1
        if start_y < 1
            mergedImage(1:h2, start_x:start_x+w2-1, :) = warpedSource;
            mergedImage(2-start_y:1-start_y+h1, 1:w1, :) = destImage;     
        else
            mergedImage(start_y:start_y+h2-1, start_x:start_x+w2-1, :) = warpedSource;
            mergedImage(1:h1, 1:w1, :) = destImage;
        end
    end
end