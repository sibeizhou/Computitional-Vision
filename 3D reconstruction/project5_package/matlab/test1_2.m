clear all
close all

load('../data/someCorresp.mat');
I1 = imread('../data/im1.png');
I2 = imread('../data/im2.png');
F = eightpoint(pts1, pts2, M);
[coordsIM1, coordsIM2] = epipolarMatchGUI(I1, I2, F);