
function [D, G, E] = WheelConfiguration(alpha, beta)

%-------------------------------------------------------------------------------
%   Calculate Matrix D, G and E.
%-------------------------------------------------------------------------------
%   Form:
%   [D, G, E] = wheelConfiguration( alpha, alpha) 
%   alpha, beta unit : degree
%-------------------------------------------------------------------------------  
%-------------------------------------------------------------------------------
%   for FS9 SDR 2023/08/28
%-------------------------------------------------------------------------------
fprintf('Wheel Configuration FS9 SDR\n');
d2r = pi/180;
if nargin==0
    alpha = 45;% in deg
    beta =  35;% in deg
end
walpha = alpha * d2r;
wbeta =  beta  * d2r;

D = [ cos(walpha)*cos(wbeta) -cos(walpha)*cos(wbeta) -cos(walpha)*cos(wbeta)  cos(walpha)*cos(wbeta); ...
      sin(walpha)*cos(wbeta)  sin(walpha)*cos(wbeta) -sin(walpha)*cos(wbeta) -sin(walpha)*cos(wbeta);...
       sin(wbeta)              sin(wbeta)              sin(wbeta)             sin(wbeta)];
 

G = D'/(D*D');
E = eye(4) - G*D;
