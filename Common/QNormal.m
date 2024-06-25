function output = QNormal(q)

len = norm(q);
if len == 0
    output = q;
else
    output = q/len;
end