function [H2to1] = computeH_norm(x1, x2)

%% Compute centroids of the points
centroid1 = [mean(x1,1)];
centroid2 = [mean(x2,1)];

%% Shift the origin of the points to the centroid
p1 = [];
p2 = [];
n = size(x1,1);
for i = 1: n
   [x_1, y_1] = deal(x1(i,1),x1(i,2));
   [x_2, y_2] = deal(x2(i,1),x2(i,2));

   p1(i,:) = [x_1, y_1, 1];
   p2(i,:) = [x_2, y_2, 1];
end

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).
S1 = [sqrt(2)/centroid1(1), 0,0;0,sqrt(2)/centroid1(2), 0;0,0,1];
S2 = [sqrt(2)/centroid2(1), 0,0;0,sqrt(2)/centroid2(2), 0;0,0,1];

%% similarity transform 1
T1 = [1, 0, centroid1(1);
      0,1,centroid1(2);
      0,0,1];
T1 = S1 * T1;

%% similarity transform 2
T2 = [1, 0, centroid2(1);
      0,1,centroid2(2);
      0,0,1];
T2 = S2 * T2; 

%% Compute Homography
p1 = (T1 * p1.').';
p2 = (T2 * p2.').';
H = computeH(p1, p2).';

%% Denormalization
H2to1 = (T2\H*T1).';
end
