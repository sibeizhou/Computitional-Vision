function [K, R, t] = estimate_params(P)
% ESTIMATE_PARAMS computes the intrinsic K, rotation R and translation t from
% given camera matrix P.

% Compute camera center c
[~, ~, V] = svd(P);
c = V(1:3,end) / V(end, end);

% Compute intrinsic matrix K and rotation matrix R
[K, R] = RQ(P(1:3, 1:3));

% Compute translation vector t
t = -R*c;
end

% Helper function for RQ decomposition
function [R Q] = RQ(A)
    [Q,R] = qr(flipud(A)');
    R = flipud(R.');
    R = fliplr(R);
    Q = Q.';
    Q = flipud(Q);

    % Adjust R and Q so that the diagonal elements of R are positive
    for n = 1:3
        if R(n,n) < 0
            R(:,n) = -R(:,n);
            Q(n,:) = -Q(n,:);
        end
    end
end