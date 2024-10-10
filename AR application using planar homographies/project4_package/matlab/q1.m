%% 4.1 Feature Detection, Description, and Matching
close all;
clear all;

I1 = imread('../data/cv_cover.jpg');
I2 = imread('../data/cv_desk.png')
[locs1, locs2] = matchPics(I1, I2);

figure();
showMatchedFeatures(I1,I2,locs1,locs2,'montage');
saveas(gcf, '../results/4_1.jpg');