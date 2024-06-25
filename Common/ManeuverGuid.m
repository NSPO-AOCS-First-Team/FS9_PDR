function [guid_profile] = ManeuverGuid(guid_cons,ManCmd, fsw)
persistent t_curr 
if isempty(t_curr) 
    t_curr = 0;
end
dt_man     = ManCmd.deltaTime;
T_VHF      = fsw.dt;
% Ql2consEnd = ManCmd.Ql2consEnd;

theta_rot = guid_cons(1);
axis_rot  = guid_cons(2:4);
Amax      = guid_cons(5);
Qi2bInit  = guid_cons(6:9);

alpha  = 1 - sqrt(1 - 4*theta_rot/(Amax*dt_man^2));
T1     = alpha*dt_man/2;
T2     = dt_man-T1;
Wrot   = alpha * Amax *dt_man/2;

% Ql2consFIP = Ql2consEnd;

if t_curr >= dt_man
    Acurr = 0;
    Wcurr = 0;
    theta_curr = theta_rot;
       
elseif t_curr >= T2 && t_curr < dt_man
    Acurr = -Amax;
    Wcurr = Amax*(dt_man - t_curr);
    theta_curr = theta_rot - 0.5*Amax * (dt_man - t_curr)^2;
    
elseif t_curr >= T1 && t_curr < T2
    Acurr = 0;
    Wcurr = Wrot;
    theta_curr = theta_rot/2 + Wrot * (t_curr - dt_man/2);
    
elseif t_curr < T1
    Acurr = Amax;
    Wcurr = Amax * t_curr;
    theta_curr = 0.5*Amax * t_curr^2;
end

Qsat2consCurr = [cos(theta_curr/2);sin(theta_curr/2).*axis_rot];
Qi2cons = QMul(Qi2bInit,Qsat2consCurr);
Wcons = Wcurr.*axis_rot;
Acons = Acurr.*axis_rot;
t_curr = t_curr + T_VHF;

guid_profile = [Qi2cons;Wcons;Acons;...
              theta_curr*180/pi; Wcurr*180/pi; Acurr*180/pi];%extra
if t_curr > dt_man
     t_curr = 0;
end


    
        
        



