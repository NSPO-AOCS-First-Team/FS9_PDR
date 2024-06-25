%%
% clear;
syms wx wy wz Ixx Iyy Izz Ixy Izy Izx hx hy hz real

Isat  = [Ixx Ixy Izx; Ixy Iyy Izy; Izx Izy Izz];
Wsat = [wx; wy;wz];
Hrw=[hx ; hy; hz];
% H = Isat*Wsat+Hrw;
% Hx = H(1);
% Hy = H(2);
% Hz = H(3);
% H=[1.5 1.5 1.5]'
H = [ 3.2678 4.3579  2.5160]';
Tpert2 = cross(Wsat,H)
% vpa(subs(Tpert2,[wx wy wz hy hz Izx Ixy],[2*3.14/180 0 0 1.5 1.5 0.846 15.127]),2)
% vpa(subs(Tpert2,[wx wy wz hx hy hz Ixy Izy Izx Ixx Iyy Izz],...
%     [1.414*3.14/180 1.414*3.14/180 0 1.5 1.5 1.5 15.127 -11.167 0.846 260.455 335.312 327.176]),2)
vpa(subs(Tpert2,[wx wy wz ],[2*3.14/180 0  0 ]),4)
vpa(subs(Tpert2,[wx wy wz ],[1.414*3.14/180 1.414*3.14/180  0 ]),4)