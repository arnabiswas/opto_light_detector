clear
clc

video_files_path = '/ssd02/Projects/Data/jen_projects/ting_optogentics';
processed_files_path = '/ssd02/Projects/Data/jen_projects/ting_optogentics/dummy_processed_files';
output_video_path = '/ssd02/Projects/Data/jen_projects/ting_optogentics/opto_out/videos';
output_optofile_path = '/ssd02/Projects/Data/jen_projects/ting_optogentics/opto_out/processed_files';
create_videos = true;
recalibrate = false;

video_files = dir(fullfile(video_files_path, '*.mp4'));
processed_files = dir(fullfile(processed_files_path, '*.xlsx'));

i = 2;

%load the processed file
proc_file = readtable(fullfile(processed_files_path, processed_files(i).name));
filename_parts = split(processed_files(i).name, 'Deep');

fprintf('\n')
fprintf(strcat(processed_files(i).name,'\n\n'));

%find the correspoding video
vid_path = fullfile(video_files_path, strcat(char(filename_parts(1)),'.mp4'));

%if the file opto_calibrate exists or if recalibrate is set to true, redo
%calibration
if ~exist('opto_calibrate.mat', 'file') == 2 || recalibrate == true
    selectCropPoints(vid_path);
else
    load('opto_calibrate.mat', 'points')
end


v = VideoReader(vid_path);
%load the video
total_frames = v.NumFrames;

%%
rand_idx = randi([1,total_frames],1,1);
%rand_idx = 8482; %6014; %
%rand_idx = 7969; %1503;%9787;
frame = read(v,rand_idx);

%imshow(frame)
rectangle = [points(2,1), points(1,2), abs(points(1,1) - points(2,1)), abs(points(1,2)-points(2,2))];
use_frame = imcrop(frame,rectangle);

% Convert the image to HSV
hsv = rgb2hsv(use_frame);

% Define the range of blue color in HSV
lower_blue = [110/180, 0.7, 0.2];
upper_blue = [130/180, 1.0, 1.0];

% Create a mask of the blue area
mask = (hsv(:,:,1) >= lower_blue(1)) & (hsv(:,:,1) <= upper_blue(1)) ...
     & (hsv(:,:,2) >= lower_blue(2)) & (hsv(:,:,2) <= upper_blue(2)) ...
     & (hsv(:,:,3) >= lower_blue(3)) & (hsv(:,:,3) <= upper_blue(3));

% Step 4: Bitwise-AND mask and original image
res = bsxfun(@times, use_frame, cast(mask,class(use_frame)));

imshow(use_frame)
% Step 5: Find contours in the mask
contours = bwboundaries(mask, 'noholes');

% If there are any contours that means we have detected blue color
if ~isempty(contours) && sum(reshape(mask,[],1))>80
    on_off = 1;
    text(50,50,'ON','Color','blue','FontSize',34)
else
    on_off = 0;
end

contours
on_off
rand_idx
sum(reshape(mask,[],1))