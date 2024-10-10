function P = estimate_pose(x, X)
% ESTIMATE_POSE computes the pose matrix (camera matrix) P given 2D and 3D
% points.
%   Args:
%       x: 2D points with shape [2, N]
%       X: 3D points with shape [3, N]
A = [];
N = size(x,2);
for i = 1 : N
    x_2D = x(1,i);
    y_2D = x(2,i);
    A = [A;
        X(:,i).', 1, zeros(1,4), -x_2D*[X(:,i).',1];
        zeros(1,4), X(:,i).', 1, -y_2D*[X(:,i).',1]];
end
[~,~,V]=svd(A);
P = reshape(V(:,end), [4,3])';

% Enforce the constraint that the last element of P is positive
if P(3,4) < 0
    P = -P;
end

end