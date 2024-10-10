function consistency = ComputeConsistency(I0,I1,X,ProMatrix_I0,ProMatrix_I1)
n = size(X,1);
C0 = zeros(n,3);
C1 = zeros(n,3);
for i = 1:n
    XYZCoord = [X(i,:),1];
    xyCoord0 = ProMatrix_I0 * XYZCoord.';
    xyCoord1 = ProMatrix_I1 * XYZCoord.';
    x0 = round(xyCoord0(1,:)/xyCoord0(3,:));
    y0 = round(xyCoord0(2,:)/xyCoord0(3,:));
    if y0 < size(I0,1) && x0 < size(I0,2) && x0 > 0 && y0 > 0
        C0(i,:) = I0(y0,x0,:); 
    end

    x1 = round(xyCoord1(1,:)/xyCoord1(3,:));
    y1 = round(xyCoord1(2,:)/xyCoord1(3,:));
    if y1 < size(I1,1) && x1 < size(I1,2) && x1 > 0 && y1 > 0
        C1(i,:) = I1(y1,x1,:); 
    end
end

consistency = NormalizedCrossCorrelation(C0, C1);

end