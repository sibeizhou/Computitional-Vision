function result = Get3dCoord(q,P,d)
x = q(2);
y = q(1);
A = [d*x - P(1,4); d*y - P(2,4); d - P(3,4)];
B = P(1:3, 1:3);

result = inv(B) * A;
end