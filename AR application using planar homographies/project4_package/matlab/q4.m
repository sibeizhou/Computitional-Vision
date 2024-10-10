%% 4.4 Homography Normalization
close all;
clear all;

I1 = imread('../data/cv_cover.jpg');
I2 = imread('../data/cv_desk.png');
[x1, x2] = matchPics(I1, I2);

figure();
showMatchedFeatures(I1,I2,x1,x2,'montage');

H2to1 = computeH_norm(x1, x2);
tform = projective2d(H2to1);
points = [randperm(350, 10).', randperm(450, 10).'];
out = transformPointsForward(tform,points);

figure();
showMatchedFeatures(I1, I2, points, out, 'montage');
saveas(gcf, '../results/4_4.jpg');
