function fsw = set_fsw_common(dm)

fsw.dt = 1/8;  %sampling time in sec 
fsw.jd0 = dm.jd0;
fsw.EstIb = CrossIneriaCheck(dm.Ib);   
% diagMOI = diag(fsw.EstIb); 
%% FSW RW Function/Equipment
fsw.rw.func.KERNEL_ANG_MOM_REF   = 1; % 2023/08/28 Jack
fsw.rw.func.KERNEL_ANG_MOM_GAIN  = 0.01;
fsw.rw.eqpt.MOI = ones(4,1)*dm.rw_mdl.moi;
fsw.rw.eqpt.H0  = [0 0 0 0]';
fsw.rw.func.D = dm.D;
fsw.rw.func.G = dm.G;
fsw.rw.func.E = dm.E; % eye(4) - G*D
fsw.rw.func.K_KERNEL_DIRECTION = [1 -1 1 -1]; % 2023/08/28 Jack
fsw.rw.func.maxTorque          =  dm.rw_mdl.maxTorque;

% alt = dm.semi_major_km - 6378.137;
[orbit_period, ~]   = GetOrbitTimeAndVelocity(dm.semi_major_km);
fsw.orbital_pulsation            = 2 * pi/orbit_period;
fsw.rw.func.off_load_ctrl_gain   = 3 * fsw.orbital_pulsation;
fsw.rw.func.h_ref                = [0,0,0]';

%% MTQ Paramters for FS9
fsw.mtq.cycle = 10;
fsw.mtq.func.max_dipole = 140; % 2023/08/28 form ZARM MT-140
fsw.mtq.func.Count_stab = 0; % check
fsw.mtq.func.Stabilized = 0; % check
fsw.wXbdot_gain         = 28 * 500;%

%% disp design paramters
% fprintf('DM  Hz  = %.1f\n',1/dm.dt);
% fprintf('FSW Hz  = %.1f\n',1/fsw.dt );
% fprintf('MTQ Max = %.1f Am^2\n',fsw.mtq.func.max_dipole);
% % fprintf('SS FOV  = %d (degree)\n', dm.ss_mdl.fov/deg2rad);
% fprintf('Wheel Kernel  = %.1f (Hms)\n', fsw.rw.func.KERNEL_ANG_MOM_REF);    

% fprintf('MOI_RATIO = \n[\t%4.1f%%\t%4.1f%%\t%4.1f%%\n\t%4.1f%%\t%4.1f%%\t%4.1f%%\n\t%4.1f%%\t%4.1f%%\t%4.1f%%\t]\n',MOI_RATIO);
