function [M1, M2, K1n, K2n, R1n, R2n, t1n, t2n] = ...
                        rectify_pair(K1, K2, R1, R2, t1, t2)
% RECTIFY_PAIR takes left and right camera paramters (K, R, T) and returns left
%   and right rectification matrices (M1, M2) and updated camera parameters. You
%   can test your function using the provided script q4rectify.m

% Compute the optical center c1 and c2
c1 = -inv(K1*R1)*(K1*t1); 
c2 = -inv(K2*R2)*(K2*t2); 

% Compute the new rotation matrix
r1 = (c1 - c2)/ norm(c1 - c2);
r2 = (cross(R1(3, :), r1))';
r3 = (cross(r2,r1));

R_new = [r1 r2 r3].';

% Compute the new intrinsic parameter
K_new = K2;

% Compute the new translation
t1n = -R_new*c1;
t2n = -R_new*c2;

% Finally, compute the rectification matrix of the first/second camera
M1 = (K_new*R_new) * inv(K1*R1);
M2 = (K_new*R_new) * inv(K2*R2);

R1n = R_new ;
R2n= R_new ;

K1n = K1 ; 
K2n = K2 ;

end