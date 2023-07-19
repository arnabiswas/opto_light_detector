function selectCropPoints(vid_path)
    v = VideoReader(vid_path);

    % Read the first frame from the video file
    first_frame = readFrame(v);

    % Display the first frame
    figure, imshow(first_frame);
    title('Click 2 points on the image, top-right and bottom-left');
    
    % Initialize points
    points = zeros(2,2);
    
    % Allow user to select 4 points
    for i = 1:2
        [x, y] = ginput(1);
        
        % Save the point to the variable
        points(i,:) = [x, y];
    
        % Display the point on the image
        hold on;
        plot(x, y, 'r*');
        hold off;
    end
    save('opto_calibrate.mat', 'points')
    close;
end
