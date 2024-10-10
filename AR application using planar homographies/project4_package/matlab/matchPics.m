function [ locs1, locs2] = matchPics( I1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!

%% Convert images to grayscale, if necessary
if size(I1,3)==3
    I1_gray = rgb2gray(I1);
else
    I1_gray = I1;
end
if size(I2,3)==3
    I2_gray = rgb2gray(I2);
else
    I2_gray = I2;
end

%% Detect features in both images
feature1 = detectSURFFeatures(I1_gray);
feature2 = detectSURFFeatures(I2_gray);

%% Obtain descriptors for the computed feature locations
[feature1,vp1] = extractFeatures(I1_gray,feature1.Location,'Method', 'SURF');
[feature2,vp2] = extractFeatures(I2_gray,feature2.Location,'Method', 'SURF');

%% Match features using the descriptors
matches = matchFeatures(feature1,feature2,'MatchThreshold', 10.0, 'MaxRatio', 0.68);

locs1 = double(vp1(matches(:,1),:).Location);
locs2 = double(vp2(matches(:,2),:).Location);

end


