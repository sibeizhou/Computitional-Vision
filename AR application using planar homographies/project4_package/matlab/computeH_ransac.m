function [ bestH2to1, inliers] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.

% Set parameters of RANSAC
numIterations = 1000; 
threshold = 3; 

bestInlierIdx = [];
best_sample = [];
maxInliers = 0;
for i = 1:numIterations
    sample = randperm(size(locs1, 1), 4); % random choose 4 points as sample
    H = computeH_norm(locs1(sample,:), locs2(sample,:));

    % calculate error
    tform = projective2d(H);
    locs1_out = transformPointsForward(tform,locs1);

    err = sum((locs2 - locs1_out).^2, 2);

    % count inliers
    inliers = find(err < threshold);
    numInliers = length(inliers);

    if numInliers > maxInliers
        best_sample = sample;
        maxInliers = numInliers;
        bestInlierIdx = inliers;
        inliers_0_1 = double(err < threshold);
    end
end

% using the inliers to get best H
bestH2to1 = computeH_norm(locs1(bestInlierIdx,:), locs2(bestInlierIdx,:));
inliers = inliers_0_1;

%% visualize the 4 point-pairs (that produced the most number of inliers)
% I1 = imread('../data/cv_cover.jpg');
% I2 = imread('../data/cv_desk.png');

% showMatchedFeatures(I1, I2, locs1(best_sample,:), locs2(best_sample,:), 'montage');
% saveas(gcf, '../results/4_5(1).jpg');

%Q2.2.3
end