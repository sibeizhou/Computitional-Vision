function [ locs1, locs2] = matchPics1( I1, I2 )
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
feature1 = detectFASTFeatures(I1_gray);
feature2 = detectFASTFeatures(I2_gray);

%% Obtain descriptors for the computed feature locations
[feature1,vp1] = computeBrief(I1_gray,feature1.Location);
[feature2,vp2] = computeBrief(I2_gray,feature2.Location);

%% Match features using the descriptors
matches = matchFeatures(feature1, feature2,'MatchThreshold', 10.0, 'MaxRatio', 0.68);
locs1 = vp1(matches(:,1),:);
locs2 = vp2(matches(:,2),:);

%% Change the parameters of matchFeatures when features return is few
% change = 0;
% while size(locs1,1) < 4
    %% Match features using the descriptors
    % matches = matchFeatures(feature1, feature2,'MatchThreshold', 10.0, 'MaxRatio', 0.6 + change*0.005);
    % locs1 = vp1(matches(:,1),:);
    % locs2 = vp2(matches(:,2),:);
    % change = change + 1;
% end

end


