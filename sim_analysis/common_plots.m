%% common plotting
% close all;
set(0,'DefaultFigureWindowStyle','docked')
global alt_b5g;
alt_b5g = norm(dm.init_pv_eci(1:3))/1e3-6378.137;
%% sc_rate
log_plot('RateSc', 'S/C Body Rates', 'deg/sec','orbit');
% figure;subplot(2,1,1);
% log_plot('MtqCmd', 'MTQ Linear Commands','Am^2','orbit',0);
% % ylim([-fsw.mtq.func.max_dipole fsw.mtq.func.max_dipole]);
% subplot(2,1,2);
% log_plot('MtqCmdPwm', 'MTQ PWM Commands','Am^2','orbit',0);
% figure;subplot(2,1,1);
log_plot('MtqCmd', 'MTQ Linear Commands','Am^2','orbit');
% ylim([-fsw.mtq.func.max_dipole fsw.mtq.func.max_dipole]);
% subplot(2,1,2);
log_plot('MtqCmdPwm', 'MTQ PWM Commands','Am^2','orbit');
log_plot('MagMeasSc', 'MAG Measurement','nT','orbit');

log_plot('RwTrq3', 'Wheel Torque Commands (3x1)', 'Nm','orbit');
log_plot('RwTrq4', 'Wheel Torque Commands (4x1)', 'Nm','orbit');

%% RW Speed
% log_plot('RwSpd', 'RW Speed (rpms)', 'rpm','orbit');
%%
log_plot('udot_norm', 'Udot Norm', 'nT/s','orbit');

%% eclipse
log_plot('<Eclipse>', 'EclipseFlag');
set_callback;
%% disturbance torques
% log_plot('dist_trq', 'Total Disturbance Torques', 'Nm');
% log_plot('gravity-gradient torque', 'Gravity Gradient Disturbance Torque', 'Nm');
% log_plot('magnetic torque', 'Magnetic Disturbance Torque', 'Nm');
% log_plot('aerodynamic torque', 'Aerodynamic Disturbance Torque', 'Nm');
% log_plot('sloar torque', 'Solar Pressure Disturbance Torque', 'Nm');

%% adjust line widths and link axes;
post_plot