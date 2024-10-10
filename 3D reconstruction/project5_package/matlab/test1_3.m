clear all
close all

load('../data/someCorresp.mat');
load('../data/intrinsics.mat');

F = eightpoint(pts1, pts2, M);
E = essentialMatrix(F, K1, K2);

scale = [1/M 0 0; 0 1/M 0; 0 0 1];
E = scale'*E*scale;

E
I1 = imread('../data/im1.png');
I2 = imread('../data/im2.png');
[coordsIM1, coordsIM2] = epipolarMatchGUI(I1, I2, E);