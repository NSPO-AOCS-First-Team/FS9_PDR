function dt = est_man_time(pv_eci_0, Qlvlh2cons_end, fsw)
% global fsw

Qi2l       = PVi2Qi2l(pv_eci_0);
Qi2bInit   = Qi2l;
Isat       = fsw.EstIb;
G          = fsw.rw.func.G;
DHalloc    = fsw.guid.WHEEL_MOM_ALLOC;
TrwMax     = fsw.guid.WHEEL_MAX_TORQUE;
Wthd       = fsw.guid.MAN_ANG_RATE_SAT;

Qi2consEnd = QMul(Qi2l, Qlvlh2cons_end);

Qman       = QMul(QInv(Qi2bInit), Qi2consEnd);
Qman       = QNormal(Qman);

if Qman(1) <0
    Qman = -Qman;
end
theta_rot = 2 * acos(Qman(1));

if theta_rot < fsw.guid.EPSILON_MAN
    theta_rot = 0;
    axis_rot  =[1 0 0]';
else
    axis_rot = Qman(2:4)/sqrt(1-Qman(1)^2);
end

Acc         = abs(G*Isat*axis_rot);
dh_over_a   = [inf inf inf inf]';
tmax_over_a = [inf inf inf inf]';
for i=1:4
    if Acc(i)~=0
        dh_over_a(i)  = DHalloc(i)/Acc(i);
        tmax_over_a(i)= TrwMax(i)/Acc(i);
    end
end
Wmax = min([dh_over_a' Wthd]);
Amax = min(tmax_over_a);

%% step 4 
if theta_rot <= Wmax^2/Amax
    dt = sqrt(4*theta_rot/Amax);
else
    dt = (theta_rot+Wmax^2/Amax)/Wmax;%(theta_rot/Wmax+Wmax/Amax); %(theta_rot+Wmax^2/Amax)/Wmax
end
dt    = (dt);

end