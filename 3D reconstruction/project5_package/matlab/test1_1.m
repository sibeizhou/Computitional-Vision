clear all
close all

load('../data/someCorresp.mat');
F = eightpoint(pts1, pts2, M);

I1 = imread('../data/im1.png');
I2 = imread('../data/im2.png');

F
displayEpipolarF(I1, I2, F);
