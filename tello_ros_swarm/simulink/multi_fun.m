
function MULTI = multi_fun(x1, y1, r1, x2, y2, r2, x3, y3, r3)

t = x1^2 + y1^2 - r1^2;

X = [2*(x1-x2) 2*(y1-y2);
    2*(x1-x3) 2*(y1-y3)];

Y = [t-x2^2-y2^2+r2^2;
    t-x3^2-y3^2+r3^2];

MULTI = inv(X'*X)*X'*Y;

end