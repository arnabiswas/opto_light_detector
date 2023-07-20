clc;
clear all;
close all;

n1 = 0 : 1 : 7;
T = readtable('/ssd02/Projects/Data/jen_projects/ting_optogentics/opto_out/processed_files/RC6-11_0.5mvDeepCut_resnet50_opto stim live testJul10shuffle1_1030000-processed.xlsx');
y1 = T.OptoLight;
h1 = ones(1,30*30);
X = conv (y1, h1, 'same');

order = 2;
framelen = 501;
y = sgolayfilt(X,order,framelen);
%pts = findchangepts(X,MaxNumChanges=8,Statistic="std");

[peakValues, indexes] = findpeaks(y, 'MinPeakHeight', 200);
scatter(indexes, ones(length(indexes),1)*200)
hold on
plot(X)

%plot(y)

light_start = zeros(1, length(indexes));
for i = 1:numel(peakValues)
    crossedThreshold = 0;
    frames = 0;
    while ~crossedThreshold
        if X(indexes(i)-frames)~= 0
            frames = frames+1;
        else
            crossedThreshold = 1;
            light_start(i) = indexes(i)-frames;
        end
    end
end

scatter(light_start, ones(length(light_start),1))
    %scatter()

%text(locs+.02,pks,num2str((1:numel(pks))'))