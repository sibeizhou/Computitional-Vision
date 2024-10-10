function E = essentialMatrix(F, K1, K2)
% essentialMatrix computes the essential matrix 
%   Args:
%       F:  Fundamental Matrix
%       K1: Camera Matrix 1
%       K2: Camera Matrix 2
%
%   Returns:
%       E:  Essential Matrix
%

% Compute the essential matrix
E = K2.' * F * K1;

% Enforce the constraint that the singular values of E are [1 1 0]
[U, S, V] = svd(E);
S(1,1) = 1;
S(2,2) = 1;
S(3,3) = 0;
E = U * S * V';

% Ensure that E has positive determinant
if det(E) < 0
    E = -E;
end

end