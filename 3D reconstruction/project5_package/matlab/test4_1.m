clear all;
close all;

% Depthmap Algorithm for reference images
I0 = imread('../data/templeR0013.png');
I1 = imread('../data/templeR0014.png');
I2 = imread('../data/templeR0016.png');
I3 = imread('../data/templeR0043.png');
I4 = imread('../data/templeR0045.png');

% Get the projection matrix for Images
ProMatrix_I0 = GetProMatrix('templeR0013.png');
ProMatrix_I1 = GetProMatrix('templeR0014.png');
ProMatrix_I2 = GetProMatrix('templeR0016.png');
ProMatrix_I3 = GetProMatrix('templeR0043.png');
ProMatrix_I4 = GetProMatrix('templeR0045.png');
proMatrixs = [ProMatrix_I0,ProMatrix_I1,ProMatrix_I2,ProMatrix_I3,ProMatrix_I4];

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


% Project them to the image and visualize the corners
Image = I0;     % change to test different image
P = ProMatrix_I0;    % change to test different image
imshow(Image);
for i = 1:8
    XYZCoord = [points(i,:),1];
    xyCoord = P * XYZCoord.';
    x0 = xyCoord(1,:)/xyCoord(3,:);
    y0 = xyCoord(2,:)/xyCoord(3,:);

    xyCoords(i,1) = x0;
    xyCoords(i,2) = y0;

    hold on;
    plot(round(x0),round(y0), 'r*');
    hold off;
end

saveas(gcf, '../result/templeR0013_withCorners.png');


