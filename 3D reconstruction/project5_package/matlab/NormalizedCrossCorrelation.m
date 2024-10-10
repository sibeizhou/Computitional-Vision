function score = NormalizedCrossCorrelation(C0, C1)
avg_r = mean(C0(:,1));
avg_g = mean(C0(:,2));
avg_b = mean(C0(:,3));

C0(:,1) = C0(:,1) - avg_r;
C0(:,2) = C0(:,2) - avg_g;
C0(:,3) = C0(:,3) - avg_b;

l2_norm = norm(C0(:));

C0 = C0 / l2_norm;

avg_r = mean(C1(:,1));
avg_g = mean(C1(:,2));
avg_b = mean(C1(:,3));
C1(:,1) = C1(:,1) - avg_r;
C1(:,2) = C1(:,2) - avg_g;
C1(:,3) = C1(:,3) - avg_b;
C1 = C1 / norm(C1(:));

C0 = C0(:)';
C1 = C1(:)';

score = dot(C0, C1);
end
