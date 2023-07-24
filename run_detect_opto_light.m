clear;
clc;

%path to videos for which you want to detect optogenetic light stimulation
video_files_path = '/ssd02/Projects/Data/jen_projects/ting_optogentics';
%path to corresponding processed files for the videos above
processed_files_path = '/ssd02/Projects/Data/jen_projects/ting_optogentics/dummy_processed_files';
%output path of processed files with OptoLight column appended in the end
output_video_path = '/ssd02/Projects/Data/jen_projects/ting_optogentics/opto_out/';
%output path to videos to verify correct detection of optogenetic light
%stimulation whenever a frame with blue light is detected the word ON
%appers on the top left corner
output_optofile_path = '/ssd02/Projects/Data/jen_projects/ting_optogentics/opto_out/';

%set to false if you do not want any output videos as stated above
create_videos = true;
%set to false if you want to recalibrate the crop points of the video, this
%is present to avoid erronous detection of blue from outside the arena
recalibrate = false;

%filters the light on off signal to be a step function is appended as
%OptoLightFiltered in the output processed file
filter_output = true;

detectOptoLight(video_files_path, processed_files_path, ...
    create_videos, recalibrate, output_video_path, ...
    output_optofile_path, filter_output);
