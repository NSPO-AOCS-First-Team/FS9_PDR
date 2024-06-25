function [T,v] = GetOrbitTimeAndVelocity(semi_major) 
% input in altitude unit:km
mu_e = 3.986004418e14; % m^3/s^2
r  = (semi_major)*10^3;  % m
T  = 2*pi*sqrt(r^3/mu_e); % sec 
v  = 2*pi*r*10^-3/T;     % km/sec