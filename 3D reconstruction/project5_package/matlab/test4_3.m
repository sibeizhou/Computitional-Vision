% Load depth map and camera matrix
% load('../data/depth_map.mat');

% Get the projection matrix for I0
[K, ProMatrix_I0] = GetProMatrix('templeR0013.png');

% Define image size
I0 = imread('../data/templeR0013.png');
height = size(I0,1);
width = size(I0,2);

% Compute 3D coordinates for each pixel with a depth value
points3d = zeros(height * width, 3);
k_inv = inv(K);
index = 1;
for i = 1:height
    for j = 1:width
        if depth_map(i, j) > 0
            homogeneous_point = k_inv * [j; i; 1;];
            points3d(index, :) = depth_map(i, j) * homogeneous_point(1:3)';
            index = index + 1;
        end
    end
end
points3d(index:end, :) = [];

% Save point cloud as OBJ file
filename = 'point_cloud.obj';
fid = fopen(filename, 'w');
fprintf(fid, 'o PointCloud\n');
for i = 1:size(points3d, 1)
    fprintf(fid, 'v %f %f %f\n', points3d(i, 1), points3d(i, 2), points3d(i, 3));
end
fclose(fid);