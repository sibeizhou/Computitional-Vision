function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.
mask = ones(windowSize, windowSize);

[height, width] = size(im1); % height = 640, width = 480
disps = zeros(height, width, maxDisp+1);
tmp = zeros(height, width);

for d = 0:maxDisp
    disp = 1:(height * (width-d));
    tmp(disp) = (im1(height*d + disp) - im2(disp)).^2;
    disps(:,:,d+1) = conv2(tmp, mask, 'same');
end

[~, inds] = min(disps, [], 3);
dispM = inds - 1;
end