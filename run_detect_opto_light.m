clear
clc

video_files_path = '/ssd02/Projects/Data/jen_projects/ting_optogentics';
processed_files_path = '/ssd02/Projects/Data/jen_projects/ting_optogentics/dummy_processed_files';
output_video_path = '/ssd02/Projects/Data/jen_projects/ting_optogentics/opto_out/videos';
output_optofile_path = '/ssd02/Projects/Data/jen_projects/ting_optogentics/opto_out/processed_files';
create_videos = true;
recalibrate = false;

filter_output = true;
min_on_duration=30; %minimum chunk of duration that the light is on
num_times_light_on=5; %how many times does the light stay on

DetectOptoLight(video_files_path, processed_files_path, create_videos, recalibrate);
