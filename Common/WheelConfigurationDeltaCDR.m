
function [D, G] = WheelConfigurationDeltaCDR(alpha, beta)

%-------------------------------------------------------------------------------
%   Calculate Matrix D and G.
%-------------------------------------------------------------------------------
%   Form:
%   [D, G] = wheelConfiguration( walpha, wbeta )
%-------------------------------------------------------------------------------  
%-------------------------------------------------------------------------------
%   by Jasck 8/17 2018 for MicroSat Project
%-------------------------------------------------------------------------------

d2r = pi/180;

if nargin ==0
    % based on BCT RW4 for Microsat PDR Agility requirement
    alpha = 30;% in deg
    beta =  33;% in deg
end
walpha = alpha * d2r;
wbeta =  beta  * d2r;

 D = [sin(wbeta)            sin(wbeta)            -sin(wbeta)            -sin(wbeta); ...
      -cos(walpha)*cos(wbeta)  cos(walpha)*cos(wbeta) -cos(walpha)*cos(wbeta)  cos(walpha)*cos(wbeta); ...
      sin(walpha)*cos(wbeta)   sin(walpha)*cos(wbeta) sin(walpha)*cos(wbeta) sin(walpha)*cos(wbeta)];

 %G = D'*inv(D*D');
  G = D'/(D*D');
 

%  swD=[D(:,2) D(:,1) D(:,4) D(:,3)]
%  Gcpp = [
%  	 0.25/sin(wbeta) -0.25/(cos(wbeta)*cos(walpha))  0.25/(sin(walpha)*cos(wbeta));
% 	 0.25/sin(wbeta)  0.25/(cos(wbeta)*cos(walpha))  0.25/(sin(walpha)*cos(wbeta));
% 	 0.25/sin(wbeta)  0.25/(cos(wbeta)*cos(walpha)) -0.25/(sin(walpha)*cos(wbeta));
% 	 0.25/sin(wbeta) -0.25/(cos(wbeta)*cos(walpha)) -0.25/(sin(walpha)*cos(wbeta))];
%  h = G * [0 14 0]'
%  h_kernel = 2.5 * kernelDirection'
%  h_final = h + h_kernel
%  h_3 = D * h_final