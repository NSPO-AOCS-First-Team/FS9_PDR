function fsw_update = set_fsw_ash(fsw0)
fsw = fsw0;
%% FSW RLPD Control Parameters
diagMOI = diag(fsw.EstIb);
zeta    = 1/sqrt(2);
fsw.RLPD.settleTime = 180; %(second) %180
fsw.RLPD.wn = 4 / (fsw.RLPD.settleTime*zeta);
fsw.RLPD.kd = 2 * zeta * fsw.RLPD.wn * diagMOI;
fsw.RLPD.kp = (fsw.RLPD.wn^2 * diagMOI)./ fsw.RLPD.kd ;

%% FSW ASH Control Processing
fsw.bdot_period        = 10; %in sec
fsw.bdot_gain          = 0.7/2;%
fsw.ash_mgr.Tstab = 8000;
fsw.ash_mgr.Tconf = 100/fsw.dt;
fsw.ash_mgr.epsilon = 0.004; %% according to udot test
fsw.ash_mgr.stop_once_stab = 0; %% stop simulation once sc is stabilized

Tu = 210; %s
Wu   = 2*pi/Tu;
Zeta = 0.707;
SOFC = tf(Wu^2,[1 2*Zeta*Wu Wu^2]);
SOFD = c2d(SOFC, fsw.bdot_period);

fsw.ash.sof.num = SOFD.Numerator{1};
fsw.ash.sof.den = SOFD.Denominator{1};

% fsw.ash_ctrl.cur_total_ang_mom_ref = 2.0;%%@@
fsw.ash_ctrl.cur_total_ang_mom_ref = 2.0;%%@@
fsw.ash_ctrl.angular_mom_dir       = [0 -1 0]';
fsw.ash_ctrl.total_ang_mom_gain    = 0.001;%
fsw_update = fsw;