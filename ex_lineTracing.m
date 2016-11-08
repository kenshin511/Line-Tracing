% line tracing_2
clear all; close all; clc;

%% Load Image
f = imread('lineCurve.jpg');
BW = ~im2bw(f);

% BW = zeros(20, 20);
% BW(5:15, 10) = 1;
% BW(5:15, 14) = 1;

%% Line Tracing
y = bwlineboundaries(BW);

figure; imshow(BW);
hold on
for m = 1 : length(y)
    for n = 1 : length(y{m})
        plot(y{m}(n, 2), y{m}(n, 1), '*r')
        drawnow, pause(0.1)
    end
end

hold off

