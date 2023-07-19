function [on_off] = detectBlueLight(img)
    % Convert the image to HSV
    hsv = rgb2hsv(img);
    
    % Define the range of blue color in HSV
    lower_blue = [110/180, 0.7, 0.2];
    upper_blue = [130/180, 1.0, 1.0];
    
    % Create a mask of the blue area
    mask = (hsv(:,:,1) >= lower_blue(1)) & (hsv(:,:,1) <= upper_blue(1)) ...
         & (hsv(:,:,2) >= lower_blue(2)) & (hsv(:,:,2) <= upper_blue(2)) ...
         & (hsv(:,:,3) >= lower_blue(3)) & (hsv(:,:,3) <= upper_blue(3));
    
    % Step 4: Bitwise-AND mask and original image
    res = bsxfun(@times, img, cast(mask,class(img)));
    
    % Step 5: Find contours in the mask
    contours = bwboundaries(mask, 'noholes');
    
    % If there are any contours that means we have detected blue color
    if ~isempty(contours) && sum(reshape(mask,[],1))>80
        on_off = 1;
    else
        on_off = 0;
    end
