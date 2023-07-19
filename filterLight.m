clc;
clear all;
close all;

n1 = 0 : 1 : 7;
T = readtable('RC6-11-05mVDeepCut_resnet50_opto stim live testJul10shuffle1_1030000-processed.xlsx');
y1 = T.OptoLight;
h1 = ones(1,30*30);
X = conv (y1, h1, 'same');
pts = findchangepts(X,MaxNumChanges=8,Statistic="std");

[peakValues, indexes] = findpeaks(X, 'MinPeakHeight', 200);
scatter(indexes, ones(length(indexes),1)*100)
hold on
plot(X)
%scatter()
