function [A, P] = GetProMatrix(Img_filename)
% Get the projection matrix for Image
fid = fopen('../data/templeR_par.txt', 'r');

C = textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'Delimiter', ' ');

fclose(fid);
A = zeros(3,3);
B = zeros(3,4);
for img = 1: size(C{1},1)
    if strcmp(Img_filename, C{1}(img))
        for i = 2:10
            A(i-1) = C{i}(img);
        end
        for i = 11:22
            B(i-10) = C{i}(img);
        end
    end
end

A = A.';
B = B.';
t = B(4,:);
C = [B(1:3,1:3), t.'];

P = A * C;



