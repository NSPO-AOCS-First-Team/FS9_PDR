%% plotASH 2022/03/03
if fsw.aocs_mode % 1==nm
    disp('ash-plotting skipped');
    return;
end

%% Stabilized Counter
log_plot('count_stab', 'Stabilized Counter');

%% count_day_night
log_plot('count_day_night', 'Day/Night Counter');

%% count_day_night
log_plot('DltAngeC2B', 'SLO Control Erros', 'deg', 'orbit');
set_callback;
%% ASH Sub Mode
figure;subplot(2,1,1);
state_plot('AOCS_MGR.ASH_MGR.object_state', 'ASH Mode', 'ASHMODE',0);
subplot(2,1,2);
log_plot('RateSc', 'S/C Body Rates', 'deg/sec','orbit',0);

%%
tlog = @(name) out.logsout.getElement(name).Values.Time;
dlog = @(name) out.logsout.getElement(name).Values.Data;
td = tlog('RateSc');
Wsc = dlog('RateSc');
Hsc = Wsc*dm.Ib;
orbit_period = 2*pi/fsw.orbital_pulsation;
orbn = td/orbit_period;
figure;plot(orbn,vecnorm(Hsc,2,2));grid;hold on;
Hy = 2*fsw.orbital_pulsation*dm.Ib(2,2);
plot(orbn,ones(length(orbn),1)*Hy);
title('Spacecraft Angular Momentum Magnitude (Nms)');


%% plot DOD
% figure;subplot(2,1,1);
% log_plot('<Eclipse>', 'Eclipse Flag', '','orbit',0);
% subplot(2,1,2);
% log_plot('dod', 'Battery Depth of Discharge', '%%','orbit',0);
% 
% 
% % ASH DoD
% figure;subplot(3,1,1);
% state_plot('AOCS_MGR.ASH_MGR.object_state', 'ASH Mode', 'ASHMODE',0);
% subplot(3,1,2);
% log_plot('RateSc', 'S/C Body Rates', 'deg/sec','sec',0);
% subplot(3,1,3);
% log_plot('dod', 'Battery Depth of Discharge', '%%','sec',0);

%%
% ASH Alpha y
log_plot('alpha_y', 'Alpha Y', 'deg', 'sec');
% ASH Alpha y dot
log_plot('alpha_y_dot', 'Alpha Y dot', 'deg', 'sec');
% Body Rate
log_plot('RateSc', 'S/C Body Rates', 'deg/sec','sec');
%State
state_plot('AOCS_MGR.ASH_MGR.object_state', 'ASH Mode', 'ASHMODE');
%sa_ang
log_plot('sa_ang', 'Solar Array Angle', 'rad');
%rw torq
log_plot('RwTrq4', 'Wheel Torque Commands (4x1)', 'Nm','sec');
%%
% td = tlog('dod');
% dod = dlog('dod');
% figure;plot(td,dod);grid;hold on;


%%  
post_plot;


