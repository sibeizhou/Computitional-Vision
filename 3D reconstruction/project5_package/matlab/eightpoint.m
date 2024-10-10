function F = eightpoint(pts1, pts2, M)
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'

%% EightPoint Algorithmn
n = size(pts1,1);
x1 = pts1(:,1)./ M;
y1 = pts1(:,2)./ M;
x2 = pts2(:,1)./ M;
y2 = pts2(:,2)./ M;

A = [x1.*x2, x1.*y2, x1, y1.*x2, y1.*y2, y1, x2, y2, ones(n,1)];
[~,~,V] = svd(A);

A = reshape(V(:,9),3,3);
[U,S,V] = svd(A);
S(3,3) = 0;
F = U*S*V.';

scale = [1/M 0 0; 0 1/M 0; 0 0 1];
F = scale.'*F*scale;
F = refineF(F,pts1,pts2);
end


