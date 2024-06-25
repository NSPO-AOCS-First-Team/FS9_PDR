function Qeci2lvlh = PVi2Qi2l(PVeci)
if(size(PVeci,1)==1)
    PVeci = PVeci';
end
Peci = PVeci(1:3);
Veci = PVeci(4:6);
x_pv = cross(Peci,Veci);
lvlhz = -Peci/norm(Peci);
lvlhy = -x_pv/norm(x_pv);
lvlhx = cross(lvlhy,lvlhz);
Mlvlh2eci = [lvlhx lvlhy lvlhz];
Qeci2lvlh = M2Q(Mlvlh2eci);
mag = norm(Qeci2lvlh);
if mag~=1 && mag~=0
    Qeci2lvlh = Qeci2lvlh/mag;
end