function fsw_update = set_fsw_nm(dm0, fsw0)
%% 2022/7/14 for FS8 MDI V6.1
fsw = fsw0;
dm  = dm0;
%% FSW Guidance
% fsw = GuidanceWmaxAmax(dm, fsw);
fsw.guid.WHEEL_MOM_ALLOC  = ones(4,1) * fsw.DeltaHalloc; 
fsw.guid.WHEEL_MAX_TORQUE = ones(4,1) * fsw.DeltaTalloc; 
fsw.guid.MAN_ANG_RATE_SAT = 1.607*pi/180;
fsw.guid.EPSILON_MAN      = 0.1*pi/180;
fsw.guid.SUP_SLEW_MODE    = 1; %tranditional

%% nm controller
diagMOI = diag(fsw.EstIb); 
fc      = 1.5/20;%1.5/20;%Hz
zeta    = 1/sqrt(2);
wc      = 2*pi*fc;

gains.PD.Kp = diagMOI*wc^2;
gains.PD.Kd = diagMOI*2*zeta*wc;
fsw.ctrl.KP    = gains.PD.Kp ./ diagMOI;  %diag(fsw.Ib) * (wc)^2;
fsw.ctrl.KD    = gains.PD.Kd ./ diagMOI; % diag(fsw.Ib) *2 * damping * wc;

fsw.ctrl.ORBIT_RATE = 1/sqrt(norm(dm.init_pv_eci(1:3))^3/dm.mu_e);

fsw.ctrl.RateBiasMax = [0.8 1.0 0.7]'*pi/180;%fix(fsw.ctrl.HallocMaxSc4RW./diag(fsw.EstIb)*1000)/1000*0.5;
fsw.ctrl.RateBiasMaxNorm = norm(fsw.ctrl.RateBiasMax);
fsw.ctrl.thet_thd = max(gains.PD.Kd./gains.PD.Kp.*fsw.ctrl.RateBiasMax)*0.8;
fprintf('thet_thd = %.1f\n',fsw.ctrl.thet_thd*180/pi);

fsw.ctrl.off_load_ctrl_gain = 3 * fsw.orbital_pulsation;
fsw.ctrl.h_ref              = [0,0,0]';

%% NM MGR
fsw.nm_mgr.eclipse_param = -sqrt(dm.semi_major_km^2-6378.137^2)*1e3;%
fsw.nm_mgr.ang_thd = 5*pi/180;
fsw.nm_mgr.Tsteady = -1;%ceil(1/(fc/sqrt(2))/2);
fsw.ttc = create_ttc(0 , TTC.IDLE);

%% IAE
gyro_hz = 32; % gyro sampling rate in Hz
fsw.iae.noise_enable = 0;
fsw.iae.rate_noise   = 0.005/60/sqrt(1/gyro_hz)*pi/180;  %0.005 deg/sqrt(hr)
fsw.iae.att_noise    = [0.0057 0.0051 0.0056]'/3*pi/180; 

%% NAV
fsw.nav.noise_enable = 0;
fsw.nav.p_noise = 3.9/3;     % m
fsw.nav.v_noise = 9/100/3; % m/sec
%% update fsw;
fsw_update = fsw;
