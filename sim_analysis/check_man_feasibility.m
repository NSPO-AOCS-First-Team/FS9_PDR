function [man_feasibility_flag, Wmax] = check_man_feasibility(pv_eci_0, dt_man, Qlvlh2cons_end, fsw)
% global fsw
Isat    = fsw.EstIb;
G       = fsw.rw.func.G;
DHalloc = fsw.guid.WHEEL_MOM_ALLOC;
TrwMax  = fsw.guid.WHEEL_MAX_TORQUE;
Wthd    = fsw.guid.MAN_ANG_RATE_SAT;

Omega          = OrbitPusaltion(pv_eci_0);
Qin2lvlh       = PVi2Qi2l(pv_eci_0);
Qin2sat_init   = Qin2lvlh;

Qlvlh_init2end = [cos(Omega(2)*dt_man/2); 0;...
                  sin(Omega(2)*dt_man/2); 0];

Qin2cons_end   = QMul(QMul(Qin2lvlh, Qlvlh_init2end), Qlvlh2cons_end);

Qman           = QMul(QInv(Qin2sat_init), Qin2cons_end);
Qman           = QNormal(Qman);

if Qman(1) <0
        Qman = -Qman;
end

if Qman(1) > 1 
    man_feasibility_flag = false;
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
Wmax = min(dh_over_a);%min([dh_over_a' Wthd]);
Amax = min(tmax_over_a);

if dt_man < fsw.dt || Amax == 0
    man_feasibility_flag = false;
    
elseif dt_man <= 2*Wmax/Amax && theta_rot<=Amax*dt_man^2/4
    man_feasibility_flag = true;
    
elseif dt_man >= 2*Wmax/Amax && theta_rot<=Wmax*dt_man-Wmax^2/Amax
    man_feasibility_flag = true;
    
else
    man_feasibility_flag = false;
end

% if(~man_feasibility_flag)
%     disp('MAN Failed');
% end
    

