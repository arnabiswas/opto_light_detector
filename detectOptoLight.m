function detectOptoLight(video_files_path, processed_files_path, create_videos, recalibrate, output_video_path, output_optofile_path, filter_output, min_on_duration)

    video_files = dir(fullfile(video_files_path, '*.mp4'));
    processed_files = dir(fullfile(processed_files_path, '*.xlsx'));
    
    %check if videos and processed files exist
    assert(isempty({video_files.name})==0, 'No video files found check video path')
    assert(isempty({processed_files.name})==0, 'No processed files found check processed files path')
    
    %create output video folder if it does not exist
    %if create_videos
    %end
    %create a waitbar
    waitbar(0,'Processing files...');
    
    
    %loop over all processed files
    for i=1:numel(processed_files)
        %load the processed file
        proc_file = readtable(fullfile(processed_files_path, processed_files(i).name));
        filename_parts = split(processed_files(i).name, 'Deep');
        
        fprintf('\n')
        fprintf(strcat(processed_files(i).name,'\n\n'));
    
        %find the correspoding video
        vid_path = fullfile(video_files_path, strcat(char(filename_parts(1)),'.mp4'));
        
        % check if file has already been processed then skip
        if ~isfile(strcat(output_optofile_path, processed_files(i).name))
            fprintf('File has already been processed\n\n')
            continue
        end
        %if the file opto_calibrate exists or if recalibrate is set to true, redo
        %calibration
        if ~exist('opto_calibrate.mat', 'file') == 2 || recalibrate == true
            selectCropPoints(vid_path);
        else
            load('opto_calibrate.mat', 'points')
        end
    
        %load the video and some error handling if a video is not found
        try
            v = VideoReader(vid_path);
        catch
            fprintf('Error reading video check if video exists or \nvideo filename EXACTLY matches processed filename\n\n')
            fprintf(strcat('Based on processed file- searching for video', vid_path,'\n\n'))
            fprintf('Whereas video folder contains these videos\n\n')
            char({video_files.name})
            delete(h)
            return;
        end
        
        %create a output video
        if create_videos
            % Create a VideoWriter object, using the same frame rate as the source video.
            outputVideo = VideoWriter(fullfile(output_video_path,strcat(char(filename_parts(1)),'_opto.avi')), 'Motion JPEG AVI'); 
            outputVideo.FrameRate = v.FrameRate;
            open(outputVideo);
        end
        
        %text position for writing onto the video
        text_position = [20 20]; % Define position for text
    
        %assign an on_off list based on number of frames
        totalFrames = v.NumFrames;
        %cropping rectangle
        rectangle = [points(2,1), points(1,2), abs(points(1,1) - points(2,1)), abs(points(1,2)-points(2,2))];
        %main list which tracks the light for all frames
        on_off_list = zeros(totalFrames,1);
        frame_count = 1;
        %loop over frames and detect blue light
        while hasFrame(v)
            % Read a frame.
            frame = readFrame(v);
            %crop frame based on saved calibration
            use_frame = imcrop(frame,rectangle);
            %run blue light detector on a frame
            on_off = detectBlueLight(use_frame);
            on_off_list(frame_count,1) = on_off;
            frame_count = frame_count +1;
            if create_videos
                % Write text on the frame.
                if on_off
                    use_frame = insertText(use_frame, text_position, 'ON', 'FontSize', 18, 'TextColor', 'blue', 'BoxOpacity', 0);
                end
                % Write the frame to the new video file.
                writeVideo(outputVideo, use_frame);
            end
        end
        
        %write to xlsx file
        if filter_output
            debug = true; % if you want to show convolution filtering plots
            on_off_list = filterLight(on_off_list, min_on_duration, v.FrameRate, debug);
        end

        %error handling for if total frames are more than total rows in the
        %.xlxs file
        if size(proc_file,1)~= size(on_off_list,1)
            fprintf('Mismatch between frames in video and .xlsx file \n')
            newFilename = fullfile(output_optofile_path,processed_files(i).name);
            proc_file = array2table(on_off_list, 'VariableNames',{'optoLight'});
            writetable(proc_file, newFilename);
        else
            proc_file.OptoLight = on_off_list;
            newFilename = fullfile(output_optofile_path,processed_files(i).name);
            writetable(proc_file, newFilename);
        end
    
        if create_videos
            close(outputVideo);
        end
    
        fprintf('Done! \n\n')
        %update waitbar
        waitbar(i/numel(processed_files))
    end
end