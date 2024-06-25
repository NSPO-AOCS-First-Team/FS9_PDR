function [omega] = OrbitPusaltion(pv_eci)
p     = pv_eci(1:3);
v     = pv_eci(4:6);
w     = norm(cross(p,v))/norm(p)^2;
omega = [0 -w 0]';
end