function QuatGuid = PvEci2Qlvlh(PVeci)
Peci=PVeci(1:3);
Veci=PVeci(4:6);
lvlhz = -Peci/norm(Peci);
lvlhy = -cross(Peci,Veci)/norm(cross(Peci,Veci));
lvlhx = cross(lvlhy,lvlhz);
Meci2lvlh = [lvlhx lvlhy lvlhz];
% QuatGuid = Mat2Q(Meci2lvlh);
QuatGuid = M2Q(Meci2lvlh);% Using M2Q in "M Libs/Common"
mag = norm(QuatGuid);
if mag~=1 && mag~=0
    QuatGuid = QuatGuid/mag;
%     disp('QNORM');
end