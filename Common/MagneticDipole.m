function B = MagneticDipole(P, mpm)

re  = 6371e3; %m
mu0 = 4*pi*1e-7; %N/A^2

m       =((4*pi*re^3/mu0).*[mpm.g11 mpm.h11 mpm.g10])';
k0      = mu0*m/(4*pi);
Pnorm   = norm(P);
R       = P/Pnorm;

y = (3*(R'*k0)*R-k0)/Pnorm^3; % T
B = y*1e9; %nT
