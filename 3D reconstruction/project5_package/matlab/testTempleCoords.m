% A test script using templeCoords.mat
%
% Write your code here
%
clear all;
close all;
warning('off', 'all');

% 1. Load the two images and the point correspondences from someCorresp.mat
load('../data/someCorresp.mat');

% 2. Run eightpoint to compute the fundamental matrix F
im1 = imread('../data/im1.png');
im2 = imread('../data/im1.png');

F = eightpoint(pts1, pts2, M);

% 3. Load the points in image 1 contained in templeCoords.mat 
%    and run your epipolarCorrespondences on them to get the corresponding points in image
load('../data/templeCoords.mat');
pts2 = zeros(size(pts1));

for i = 1 : size(pts1, 1)
    pts2(i,:) = epipolarCorrespondence(im1, im2, F, pts1(i,:));
end

% 4. Load intrinsics.mat and compute the essential matrix E.
load('../data/intrinsics.mat');
E = essentialMatrix(F, K1, K2);

% 5. Compute the first camera projection matrix P1 and use camera2.m to compute the four candidates for P2
P1 = [eye(3),zeros(3,1)];
candidates_P2 = camera2(E);

% 6. Run your triangulate function using the four sets of camera matrix candidates (candidates_P2), 
%    the points from templeCoords.mat (pts1) and their computed correspondences (pts2).
least_cost = inf;
for i = 1: size(candidates_P2, 3)
    if det(candidates_P2(1:3,1:3,i)) ~= 1
        candidates_P2(:,:,i) = candidates_P2(:,:,i);
        X = triangulate(K1 * P1, pts1, K2 * candidates_P2(:,:,i), pts2);
        X = [X, ones(size(X,1),1)];

        x1 = K1 * P1 * X.';
        x1 = (x1/x1(3,:)).';
        x2 = K2 * candidates_P2(:,:,i) * X.';
        x2 = (x2/x2(3,:)).';

        % 7. Figure out the correct P2 and the corresponding 3D points.
        if all(X(:,3)>0)
            dist1 = norm(pts1-x1(:,1:2)) / size(X,1);
            dist2 = norm(pts2-x2(:,1:2)) / size(X,1);
            if dist1+dist2 < least_cost
                least_cost = (dist1+dist2);
                pts3d = X;
                P2 = candidates_P2(:,:,i);
                final_i = i;
            end
        end
    end
end
plot3(pts3d(:,1), pts3d(:,2), pts3d(:,3), 'b.', 'MarkerSize', 10);
axis equal
R1 = P1(1:3,1:3);
t1 = P1(:,4);
R2 = P2(1:3,1:3);
t2 = P2(:,4);

% save extrinsic parameters for dense reconstruction
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');
