function [outputArg1,outputArg2] = DetectOptoLight(video_files_path,processed_files_path, create_videos, recalibrate)

    videos = dir(fullfile(video_files_path, '*.mp4'));
    processed_files = dir(fullfile(processed_files_path, '*.csv'));
    
    %check this is not empty
    if create_videos
        % Create a VideoWriter object, using the same frame rate as the source video.
        outputVideo = VideoWriter('outVideo.mp4', 'MPEG-4'); 
        outputVideo.FrameRate = v.FrameRate;
    end
    
    %if the file opto_calibrate exists or if recalibrate is set to true, redo
    %calibration
    if ~exist('opto_calibrate.mat', 'file') == 2 || recalibrate == true
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
    else
        load('opto_calibrate.mat', 'points')
    end
    
    %loop over all processed files
    for processed_file=processed_files
        %load the processed file
        proc_file = readtable(processed_file);
        %find the correspoding video
        %load the video
        v = VideoReader(vid_path);
        %main list which tracks the light for all frames
        on_off_list = [];
        %loop over frames and detect blue light
        while hasFrame(v)
            % Read a frame.
            frame = readFrame(v);
            %crop frame
            use_frame = frame()
            %run blue light detector on a frame
            on_off = detectBlueLight(frame);
            on_off_list = [on_off_list,on_off];
            if create_videos
                % Write text on the frame.
                position = [10 10]; % Define position for text
                frame = insertText(frame, position, 'ON', 'FontSize', 18, 'TextColor', 'white', 'BoxOpacity', 0);
                % Write the frame to the new video file.
                writeVideo(outputVideo, frame);
            end
        %make directory if it does not exist and save after appending
        proc_file.NewColumn = on_off_list;
        newFilename = 'myData_new.csv';  % replace with your new .csv file name
        writetable(T, newFilename);
    
        if create_videos
            close(outputVideo);
        end
        end
    end