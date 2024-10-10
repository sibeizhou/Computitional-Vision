clear all;
close all;

load('../data/someCorresp.mat');

im1 = imread('../data/im1.png');
im2 = imread('../data/im1.png');
F = eightpoint(pts1, pts2, M);

load('../data/intrinsics.mat');
E = essentialMatrix(F, K1, K2);

P1 =  K1 * [eye(3),zeros(3,1)];
candidates_P2 = camera2(E);

least_err1 = inf;
least_err2 = inf;
for i = 1: 4
    candidates_P2(:,:,i) = K2 * candidates_P2(:,:,i);
    p3d = triangulate(P1, pts1, candidates_P2(:,:,i), pts2);
    p3d = [p3d, ones(size(p3d,1),1)];

    re_pro1 = (P1*p3d.');
    re_pro2 = (candidates_P2(:,:,i)*p3d.');
    re_pro1 = (re_pro1./re_pro1(3,:)).';
    re_pro2 = (re_pro2./re_pro2(3,:)).';

    pts_err1 = norm(pts1-re_pro1(:,1:2)) / size(p3d,1);
    pts_err2 = norm(pts2-re_pro2(:,1:2)) / size(p3d,1);
    if all(p3d(:,3)>0)
        if pts_err1+pts_err2 < least_err1 + least_err2
            least_err1 = pts_err1;
            least_err2 = pts_err2;
            pts3d = p3d;
            P2 = candidates_P2(:,:,i);
            final_i = i;
        end
    end
end
fprintf('Re-projection error of pts1 = %.4f\n', least_err1);
fprintf('Re-projection error of pts1 = %.4f\n', least_err2);

