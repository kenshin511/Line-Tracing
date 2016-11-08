function [y1 y2 y3] = neighArray()
% 8-connected neighbood
% y1: clock wise, 15 x 2
% y2: anticlock wise, 15 x 2
% y3: direction array, 1 x 15

y1 = [0 -1; -1 -1; -1 0; -1 1; 0 1; 1 1; 1 0; 1 -1; % clock
    0 -1; -1 -1; -1 0; -1 1; 0 1; 1 1; 1 0];
y2 = [0 -1; 1 -1; 1 0; 1 1; 0 1; -1 1; -1 0; -1 -1; % anticlock
    0 -1; 1 -1; 1 0; 1 1; 0 1; -1 1; -1 0];
y3 = [7 7 1 1 3 3 5 5 7 7 1 1 3 3 5 ];