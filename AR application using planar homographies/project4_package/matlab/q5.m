%% 4.5 RANSAC
close all;
clear all;

I1 = imread('../data/cv_cover.jpg');
I2 = imread('../data/cv_desk.png');
[x1, x2] = matchPics(I1, I2);

figure();
showMatchedFeatures(I1,I2,x1,x2,'montage');

[bestH2to1, inliers] = computeH_ransac(x1, x2);
tform = projective2d(bestH2to1);
points = [];
for i = 1: size(x1,1)
    if inliers(i,1) == 1
        points = [points; x1(i,:)];
    end
end
out = transformPointsForward(tform,points);

figure();
showMatchedFeatures(I1, I2, points, out, 'montage');
saveas(gcf, '../results/4_5(2).jpg');