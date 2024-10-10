function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2
pts2 = zeros(size(pts1));
x1 = pts1(1,1);
y1 = pts1(1,2);
pts1 = [x1; y1; 1];

eline = F * pts1;
eline = eline / sqrt(eline(1)^2+eline(2)^2);

window_width = 5;
window1 = double(im1(y1-window_width: y1+window_width, x1-window_width: x1+window_width,:));

height = size(im2,1);
width = size(im2,2);
least_dist = inf;
for x = pts1(1)-20: pts1(1)+20
   y = -(eline(1) * x + eline(3))/eline(2);
   pts = round([x, y, 1]);
   if (x-window_width>0) && (x+window_width<=width) && (y-window_width>0) && (y+window_width<=height)
       window2 = double(im2(y-window_width: y+window_width, x-window_width: x+window_width,:));
       dist = sum(sqrt(window1 - window2).^2); % Euclidean distance
       if dist < least_dist
           least_dist = dist;
           pts2 = [pts(1), pts(2)];
       end 
   end
end
