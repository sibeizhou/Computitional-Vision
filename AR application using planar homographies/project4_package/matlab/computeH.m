function [ H2to1 ] = computeH( x1, x2 )
%COMPUTEH Computes the homography between two sets of points
n = size(x1,1);
X = [];
for i = 1: n
   [x_1, y_1] = deal(x1(i,1),x1(i,2));
   [x_2, y_2] = deal(x2(i,1),x2(i,2));

   X(2*i-1,:) = [x_1, y_1, 1, 0, 0, 0, -x_1.*x_2, -x_2.*y_1, -x_2];
   X(2*i,:) = [0, 0, 0, x_1, y_1, 1, -x_1.*y_2, -y_2.*y_1, -y_2];
end

if n <= 4
    [U,S,V] = svd(X);
else
    [U,S,V] = svd(X,'econ');
end

V = reshape(V(:,end),3,3);
H2to1= V;
end