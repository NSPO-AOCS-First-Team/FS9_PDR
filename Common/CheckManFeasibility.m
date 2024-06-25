function [man_flag, guid_cons] = CheckManFeasibility(ManCmd, NAV, IAE, fsw)

%%
dt_man     = ManCmd.deltaTime;
Ql2consEnd = ManCmd.Ql2consEnd;
orbpulse   = NAV(fsw.nav.idx.orbPulse);
omega_y    = orbpulse(2);
Qi2l       = NAV(fsw.nav.idx.qi2l);
Qi2bInit   = IAE(fsw.iae.idx.qi2b);
Isat       = fsw.Ib;
T_VHF      = fsw.dt;
G          = fsw.rw.func.G;
DHalloc    = fsw.guid.WHEEL_MOM_ALLOC;
TrwMax     = fsw.guid.WHEEL_MAX_TORQUE;
Wthd       = fsw.guid.MAN_ANG_RATE_SAT;

%%
QlInit2End = [cos(omega_y*dt_man/2) 0 sin(omega_y*dt_man/2) 0]';
Qi2consEnd = QMul(QMul(Qi2l,QlInit2End), Ql2consEnd);
Qman       = QMul(QInv(Qi2bInit), Qi2consEnd);
Qman       = QNormal(Qman);

if Qman(1) <0
    Qman = -Qman;
end

if Qman(1)>1
    man_flag = 0;
    guid_cons = zeros(1+3+1+4,1);
    return;
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
if dt_man < T_VHF || Amax == 0
    man_flag = 0;
elseif dt_man <= 2*Wmax/Amax && theta_rot <= (Amax*dt_man^2)/4
    man_flag = 1;
elseif dt_man >= 2*Wmax/Amax && theta_rot <= Wmax*dt_man-Wmax^2/Amax
    man_flag = 1;
else
    man_flag = 0;
end
    
guid_cons = [theta_rot;axis_rot;Amax;Qi2bInit];

end