
function [D, G, E] = WheelConfiguration(theta, phi)

%-------------------------------------------------------------------------------
%   Calculate Matrix D, G and E.
%-------------------------------------------------------------------------------
%   Form:
%   [D, G, E] = wheelConfiguration( theta, phi) 
%   theta, phi unit : degree
%-------------------------------------------------------------------------------  
%-------------------------------------------------------------------------------
%   by Jasck 8/17 2018 for MicroSat Project
%   by Ben   9/16 2020 for MicroSat Project
%-------------------------------------------------------------------------------

d2r = pi/180;

if nargin ==0
    % based on BCT RW4 for Microsat PDR Agility requirement
    theta = 30;% in deg
    phi =  33;% in deg
end
wtheta = theta * d2r;
wphi =  phi  * d2r;

 D = [ cos(wtheta)*cos(wphi)   cos(wtheta)*cos(wphi) -cos(wtheta)*cos(wphi)  -cos(wtheta)*cos(wphi); ...
      -sin(wtheta)*cos(wphi)   sin(wtheta)*cos(wphi) -sin(wtheta)*cos(wphi)   sin(wtheta)*cos(wphi); ...
       sin(wphi)               sin(wphi)              sin(wphi)               sin(wphi);];


  G = D'/(D*D');
  E = eye(4) - G*D;
 

