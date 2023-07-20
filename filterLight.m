function [on_off_list_out] = filterLight(on_off_list_in, min_on_duration, framerate, debug)
%FILTERLIGHT Summary of this function goes here
%   use debug to make descriptive plots to help set parameters

%convolving on_off_list with a canonical signal on min_on_duration
canonical_signal = ones(1,min_on_duration*framerate);
conv_out = conv(on_off_list_in, canonical_signal, 'same');

order = 2;
framelen = 1001;
filtered_conv = sgolayfilt(conv_out,order,framelen);
peak_threshold = ceil(min_on_duration*framerate*0.25);
peak_width_threshold = ceil(min_on_duration*framerate *0.1);

[~, light_end] = findpeaks(filtered_conv, 'MinPeakHeight', peak_threshold);
[~,light_start] = findpeaks(-filtered_conv, 'MinPeakWidth', peak_width_threshold); %assumes light start and end will be the same, not always true
   
if debug
    figure
    plot(conv_out)
    hold on
    scatter(light_end, ones(length(light_end),1)*200)
    %scatter(light_start, ones(length(light_start),1))
    scatter(light_start, ones(length(light_start),1))
end

% sliding window search moving forward from troughs in convolution signal
%this indicates when the light starts
for i = 1:numel(light_end)
    frames = 1;
    while conv_out(light_start(i))-conv_out(light_start(i)+frames)==0
            frames = frames+1;
    end
    light_start(i) = light_start(i)+frames;
    
end

on_off_list_out = zeros(length(on_off_list_in),1);

for i = 1:numel(light_end)
    on_off_list_out(light_start(i):light_end(i))=1;
end

if debug
    plot(on_off_list_out*200)
end