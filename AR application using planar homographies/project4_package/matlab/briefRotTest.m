% Your solution to Q2.1.5 goes here!
close all
clear all
%% Read the image and convert to grayscale, if necessary
img = imread('../data/cv_cover.jpg');
if size(img,3)==3
    img = rgb2gray(img);
end
%% Compute the features and descriptors

% feature = detectFASTFeatures(img);
% [feature,vp] = computeBrief(img,feature.Location);
feature = detectSURFFeatures(img);% use a feature detector detectSURFFeatures instead
[feature,vp] = extractFeatures(img,feature.Location,'Method', 'SURF'); % use a extractFeatures(..., ,Method’, ‘SURF’) instead 

count = [];
for i = 0:36
    %% Rotate image
    img_rotate = imrotate(img,(i)*10);
    
    %% Compute features and descriptors
    % feature_rotate = detectFASTFeatures(img_rotate);
    feature_rotate = detectSURFFeatures(img_rotate); 

    % [feature_rotate,vp_rotate] = computeBrief(img_rotate,feature_rotate.Location);
    [feature_rotate,vp_rotate] = extractFeatures(img_rotate,feature_rotate.Location, 'Method', 'SURF');
    
    %% Match features
    matches = matchFeatures(feature,feature_rotate,'MatchThreshold', 10.0, 'MaxRatio', 0.68);
    if mod(i, 13) == 0 % only 0, 13, 26 (3 different orientations)
        locs1 = vp(matches(:,1),:);
        locs2 = vp_rotate(matches(:,2),:);
        figure();
        showMatchedFeatures(img,img_rotate,locs1,locs2,'montage');
        filename = "../results/4_2(2)_" + i*10 + ".jpg";
        saveas(gcf, filename); 
    end
    count = [count, size(matches(:,1), 1)];
    %% Update histogram
end

%% Display histogram
figure()
bar(count)
saveas(gcf, "../results/4_2(2)_histogram.jpg"); 