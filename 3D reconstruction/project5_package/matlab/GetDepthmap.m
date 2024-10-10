clear all;

% Get 8 depth values
% Depthmap Algorithm for reference I0
I0 = imread('../data/templeR0013.png');

% Get the projection matrix for I0
[~,ProMatrix_I0] = GetProMatrix('templeR0013.png');

Mins = [-0.023121 -0.038009 -0.091940];
minx = Mins(1);
miny = Mins(2);
minz = Mins(3);

Maxs = [0.078626 0.121636 -0.017395];
maxx = Maxs(1);
maxy = Maxs(2);
maxz = Maxs(3);

% The the 8 corners
P1 = [minx, miny, minz];
P2 = [minx, miny, maxz];
P3 = [minx, maxy, minz];
P4 = [minx, maxy, maxz];
P5 = [maxx, miny, minz];
P6 = [maxx, miny, maxz];
P7 = [maxx, maxy, minz];
P8 = [maxx, maxy, maxz];
points = [P1; P2;P3;P4;P5;P6;P7;P8];

% Project them to the image and visualize the corners to get depth
Image = I0;
P = ProMatrix_I0;
depths = [];
for i = 1:5
    XYZCoord = [points(i,:),1];
    xyCoord = P * XYZCoord.';

    x0 = xyCoord(1,:)/xyCoord(3,:);
    y0 = xyCoord(2,:)/xyCoord(3,:);
  
    depth = xyCoord(3,:);
    depths = [depths, depth];
end

% Depthmap Algorithm for reference images
I1 = imread('../data/templeR0014.png');
I2 = imread('../data/templeR0016.png');
I3 = imread('../data/templeR0043.png');

% Get the projection matrix for Image
[~,ProMatrix_I1] = GetProMatrix('templeR0014.png');
[~,ProMatrix_I2] = GetProMatrix('templeR0016.png');
[~,ProMatrix_I3] = GetProMatrix('templeR0043.png');

I0_gray = rgb2gray(I0);

depth_map = zeros(size(I0,1), size(I0,2));
for p = 1:numel(I0_gray)
    threshold = 40;
    if I0_gray(p) < threshold
        continue;
    end
    S = 5;
    [rows, cols] = ind2sub(size(I0_gray),p);

    P = [];
    for i = -(S-1)/2 : (S-1)/2
        for j = -(S-1)/2 : (S-1)/2
            P = [P; rows+i, cols+j];
        end
    end

    min_depth = min(depths);
    max_depth = max(depths); 
    depth_step = 0.05;

    best_depth = 0;
    best_consistency_score = 0;
    for d = min_depth:depth_step:max_depth
        X = zeros(S^2, 3);
        for q = 1:S^2 
            X(q,:) = Get3dCoord(P(q,:), ProMatrix_I0, d); % Get 3d coordinate
        end

        score01 = ComputeConsistency(I0,I1,X,ProMatrix_I0,ProMatrix_I1); 
        score02 = ComputeConsistency(I0,I2,X,ProMatrix_I0,ProMatrix_I2);
        score03 = ComputeConsistency(I0,I3,X,ProMatrix_I0,ProMatrix_I3);
        avg_score = mean([score01,score02,score03]); 
        if avg_score > best_consistency_score 
            best_consistency_score = avg_score;
            best_depth = d;
        end
    end
    % if best_consistency_score < 0.7 % Skip if consistency score below threshold
        % continue;
    % end
    depth_map(rows,cols) = best_depth;
end

figure; imagesc(depth_map.*(I0_gray>40)); colormap(gray); axis image;


