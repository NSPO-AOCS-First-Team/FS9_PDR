%% FS9 2023/09/08 for FS9 AOCS Sim for SDR
global sim_case ;
[rads2rpm, deg2rad] = sim_initials;
prj.name    = 'FS9';
prj.phase   = 'SDR';
%%
set_mdl_variant;
dm = set_scenario_inc97(1);
%%
dm.moi_ver = 1; % MOI Version
dm = set_dm(dm);
CrossIneriaCheck(dm.Ib); 
dm = set_eps(dm);
%% set AOCS fsw paramters for FS9 MDR with B5G-like MDI
fsw = set_fsw_common(dm);
fsw = set_fsw_ash(fsw); 
fsw = GuidanceWmaxAmax(dm, fsw,prj);
fsw = set_fsw_nm(dm,fsw);
show_update_parameters(dm, fsw);


%%
function [rads2rpm, deg2rad] = sim_initials
addpath('./common');
addpath('./design_tuning');
addpath('./sim_config');
addpath('./sim_analysis');
addpath('./fsw_init');
addpath('./models');
addpath('./reports');
addpath('./sim_scenario');
rads2rpm    = 60/(2*pi);  %rad/s to rpm
deg2rad     = pi/180;
end

%%
function show_update_parameters(dm, fsw)
    fprintf('alt \t\t\t= %.1f km\n',dm.semi_major_km-dm.earth_radius_km);
    fprintf('Idiag \t\t\t= [ %.1f %.1f %.1f ]\n',diag(dm.Ib));
    fprintf('MOI Uncertainty =  %.1f%%\n',dm.moi_margin*100);
    fprintf('DM Hz \t\t\t= %.1f\n',1/dm.dt);
    fprintf('FSW Hz \t\t\t= %.1f\n',1/fsw.dt );
    fprintf('MTQ Max \t\t= %.1f Am^2\n',fsw.mtq.func.max_dipole);
    fprintf('Wheel Kernel \t= %.1f (Hms)\n', fsw.rw.func.KERNEL_ANG_MOM_REF); 
    fprintf('fsw.DeltaTalloc = %.3f\n',fsw.DeltaTalloc);
end
