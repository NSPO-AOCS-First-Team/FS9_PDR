%% B5G PDR for ASH
addpath('./Common');
addpath('./DesignTuning');
addpath('./sim_config');
addpath('./sim_analysis');
addpath('./fsw_init');
addpath('./mdls');
rads2rpm    = 60/(2*pi);  %rad/s to rpm
deg2rad     = pi/180;

% set model contrl
mdl = set_model_control();
dm  = set_scenario_inc53(9);
dm  = set_dm(dm);
set_fsw_common;
set_fsw_ash;
set_mdl_variant;
% mdl = show_test_case(mdl);
% Simulink.SimulationData.signalLoggingSelector(mdl.sim_model)
%% 01 run simulation in the end--------------------------------------------
open_system(mdl.sim_model);
dm.duration = 6000;
sim_out = sim(mdl.sim_model);
global out
out = sim_out ;
%% plotASH
plotASH;

if mdl.Enables.stk_log
    %%
    GenStkAttEphRev;
end

%% clear variables except simulation out logs
clearvars -except out fsw mdl dm

%open('b5g_post_param_sdr_v1.m');


function dm = set_scenario_inc53(case_num)
% DM Date Time / Orbit Inc = 53 deg
    dm.duration    = 500;
    if nargin <1
        case_num = 1;
    end
    % all for Alt: 600Km, Inclination: 53 deg
    switch case_num
        case 1 %Beta Angle: -76.092 degree all in SUP!!
            dm.epoch.utc   = [2022 12 31 7 28 0]; 
            %Orbit nclination: 53 degree  Beta Angle: -76.092 degree 
            dm.init_pv_eci = [4567083.732 -2663824.282  4554139.037...
                              5612.422155  3679.414992 -3476.197541];  
              
        case 2 % Beta Angle: 0.002
            dm.epoch.utc   = [2022 6 26 8 36 0];
            dm.init_pv_eci = [197468.331     6046878.677     3477162.710  ...
                              -5168.681864     2874.655283    -4705.572364 ]; 
       
        case 3 % Beta Angle:74.302
            dm.epoch.utc   = [2022 7 16 13 46 0]; %Beta Angle: 0 degree
            dm.init_pv_eci = [2260139.074 4824572.360 -4506625.001 ...
                              -6672.890243 -184.423498 -3543.987903]; 
        case 4 % Beat Angle : -65.469
            dm.epoch.utc   = [2022 10 26 11 32 0]; 
            dm.init_pv_eci = [-2130667.541    -4179166.062     5166161.326 ...
                              4869.096076    -5308.955708    -2286.529942]; 
        case 5 % Beta Angle:74.479
            dm.epoch.utc   = [2021 7 14 22 40 0];
            dm.init_pv_eci = [-3200.6275252522    -4784.6209698159    3929.9001904527 ...
                                     6.2106386774    -0.6413611946    4.2637089292]*1e3;
       case 6 % Beta Angle: -1.595
            dm.epoch.utc   = [2021 9 2 0 0 0];
            dm.init_pv_eci = [6275.2172596517 974.7666255890 2832.5809339471...
                               -3.0645892429 4.5824083837 5.2011793797]*1e3;   
       case 7 %Beta Angle: -76.092 degree all in SUP!!
            dm.epoch.utc   = [2021 12 30 6 52 0];               
            dm.init_pv_eci = [6830881.949 72473.54  1424147.245...
                          1166.860992  4660.91645 -5834.00546]; 
       case 8 % Beta Angle: 35.066
            dm.epoch.utc   = [2021 4 29 4 0 0];
            dm.init_pv_eci = [6964.076958 456.250735 -106.229598...      
                               -0.383019 4.533041 -6.031574]*1e3;   
       case 9 %Beta Angle: -34.918
            dm.epoch.utc   = [2021 10 14 12 0 0];               
            dm.init_pv_eci = [2881.973150 -4495.748931 4444.824251...
                                6.627254 0.658516 -3.622610]*1e3;                          
       case 10 % Beta Angle: -0.021 SOMETHING WRONG!!!!!
            dm.epoch.utc   = [2021 9 2 9 20 0];
            dm.init_pv_eci = [4854.8180169595    -3687.2840835783    -3364.6825098802...
                               5.2553966140    2.5475347205    4.8128961210]*1e3;
        case 11 % Beta Angle:76.066
            dm.epoch.utc   = [2022 6 13 14 0 0];
            dm.init_pv_eci = [6281843.96391145    -2.45758894e+06    1635086.46348749 ... % m
                              3028.46613015    3857.57446306    -5786.27668016];   % m/s
                         
    end
%     dut1        = -204.8704e-3; %sec 
%     dut1        = -0.0431340; % for case 9, 2021 10 14
    dut1        = 0.0; % 
    dm.epoch.ut1   = [dm.epoch.utc(1:5) dm.epoch.utc(6)+dut1];
    dm.jd0         = DateTime2JD(dm.epoch.ut1);
    dm.dt          = 1/4;

end


function dm = set_dm(dm)
    % basic
    dm.mu_e        = 3.986004418e14; % m^3/s^2
    dm.dt  = 1/8; % sampling time
    deg2rad     = pi/180;
    
    %% DM SC Dynamic
    % B5G Satellite Mass Properties Prediction V1-0
    % Date:2021/12/24
    % unit : kg*mm^2
%     Ixx Ixy Ixz 1.0821104e+08 5.7340911e+05 1.4462713e+05
%     Iyx Iyy Iyz 5.7340911e+05 1.9372856e+08 3.8059620e+06
%     Izx Izy Izz 1.4462713e+05 3.8059620e+06 1.9206958e+08
    dm.Ib0 = [ 1.0821104e+08 5.7340911e+05 1.4462713e+05;...
              5.7340911e+05 1.9372856e+08 3.8059620e+06;...
              1.4462713e+05 3.8059620e+06 1.9206958e+08]; 
    dm.satelliteCenter = [-3.1627622e+00 1.2768906e+01 5.1648061e+02]; % center of satellite
     
    dm.Ib0 = dm.Ib0.*1e-6; %kg/m^2
    dm.Ib  = dm.Ib0 *1.2; % add 20% margin 
    dm.h0      = [0 0 0]';                                % wheel angular momentum in Nms
    dm.Nb0     = zeros(3,1);                              % external torque in Nm
    dm.w0  = [0.5 -0.5 0.5]'*deg2rad; 
    dm.Qi2b0   = PVi2Qi2l(dm.init_pv_eci');               % initial attitude ECI to Body
    dm.L0      = dm.Ib*dm.w0 + dm.h0;                     % initial SC angular momentum

    %% DM Reaction Wheel Model
    dm.rw_mdl.maxTorque = 0.25;                        % Nm
    dm.rw_mdl.maxAngMom = 4;                           % Nms
    dm.rw_mdl.avlAngMom = 3;                           % availabe torque(Nms)
    dm.rw_mdl.moi       = 0.006387;                    % kg*m2 
    dm.rw_mdl.init_spd  = [0 0 0 0]';                  % rad/sec for RW 1/2/3/4 
    dm.rw_mdl.tau_v     = 0; %0*4e-5;                  % Viscous in Nm
    dm.rw_mdl.tau_c     = 0; %0*5e-4;                  % Coulomb Friction in Nm
    dm.rw_mdl.dead_zone = 3e-1;                        % rad/sec
    
    %% DM RW Configuration
%     theta        = 46;  %  degree
%     phi          = 39;  %  
    
    %% FS8 RW Config
    theta        = 53.12;  %  degree
    phi          = 24.79;  %
    [dm.D, dm.G, dm.E] = WheelConfiguration(theta, phi);
    dm.rw2sat = dm.D;
   
    % DM Sun Sensor Model
    dm.ss_mdl.fov = (60-5)*deg2rad; % 5 deg margin
    fprintf('\ndm.ss_mdl.fov = %d (degree)\n', dm.ss_mdl.fov/deg2rad);
%     dm.ss_mdl.los = [0 0 -1]';                         % Line Of Sight vector in S/C frame
    dm.ss1_mdl.los = [0 cosd(47.5) -sind(47.5)]';      % Line Of Sight vector in S/C frame
    dm.ss2_mdl.los = [0 -cosd(47.5) -sind(47.5)]';     % Line Of Sight vector in S/C frame
    
    % Magnetic Dipole Model (mpm)
    % IGRF_2020 
    dm.mpm.g10 = -29404.8e-9;                             % Tesla
    dm.mpm.g11 = -1450.9e-9;                              % Tesla
    dm.mpm.h11 = 4652.5e-9;                               % Tesla

    % DM Disturbance
    dm.residualMagneticMoment = [0.6 0.6 0.6] * 2;                      % Unit: Nm (Need to confirm)
    dm.area    = [1247689; 1318060; 1247689; 1318060; 1318060;...        % a1~a5  unit: mm2
                  1318060; 2250000; 2250000; 2250000; 2250000];          % a6~a10 unit: mm2
    % normal vector of each area 
    dm.norV     = [ 0  0  1;                                            % n1
                   -1  0  0;                                            % n2
                    0  0 -1;                                            % n3
                    1  0  0;                                            % n4
                    0  1  0;                                            % n5
                    0 -1  0;                                            % n6
                    0  0 -1;                                            % n7
                    0  0 -1;                                            % n8
                    0  0  1;                                            % n9
                    0  0  1];                                           % n10 
    % center of each area 
    dm.areaCenter = [

% B5G area assumption
          -3.9838,    5.6529,  1180.0;                                % c1
        -592.4838,    5.6529,   590.0;                                % c2
          -3.9838,    5.6529,       0;                                % c3
         584.5162,    5.6529,   590.0;                                % c4
           3.9838,  594.1529,   590.0;                                % c5
           3.9838, -582.8471,   590.0;                                % c6
           1709.5,    5.6529,       0;                                % c7
          -1717.5,    5.6529,       0;                                % c8
           1709.5,    5.6529,      26;                                % c9
          -1717.5,    5.6529,      26];                               % c10
    
%     dm.satelliteCenter = [-1.2539021e+00, 5.1335383e+00, 6.4719996e+02]; % center of satellite    
    

    for i = 1:length(dm.areaCenter)
        dm.rs(i,:) = (dm.areaCenter(i,:) - dm.satelliteCenter)*10^-3;   %unit:m^2
    end

    dm.Ca = 0.72;
    dm.Cs = 1 - dm.Ca;
    dm.Cd = 0.0;
    dm.P = 4.66e-06;
    % dm.airDensity = 2.6789e-13;                      % air density at 561 km
    dm.airDensity = 1.4540e-13;                        % air density at 600 km
    dm.aeroCoeffDrag = 2.0;                            % coefficient of drag

end
% 
% function fsw = set_fsw(dm)
%     fsw.dt = 1/8;  %sampling time in sec
%     fsw.EstIb = CrossIneriaCheck(dm.Ib);   
%     diagMOI = diag(fsw.EstIb); 
% %     fc      = 1.5/30; %0.1;%Hz
%     zeta    = 1/sqrt(2);
% %     wc      = 2*pi*fc;
%    
%     %% FSW RW Function/Equipment
%     fsw.rw.func.KERNEL_ANG_MOM_REF   = 0.2;               % 1.3; %UPDATE!!
%     fsw.rw.eqpt.MOI = ones(4,1)*dm.rw_mdl.moi;
%     fsw.rw.eqpt.H0  = [0 0 0 0]';
%     fsw.rw.func.D = dm.D;
%     fsw.rw.func.G = dm.G;
%     fsw.rw.func.E = dm.E; % eye(4) - G*D
%     fsw.rw.func.KP                   = 0.01;%
%     fsw.rw.func.PITCH_BIAS           = [0 -2 0] * 1;%%@@
%     fprintf('\nfsw.rw.func.PITCH_BIAS = [%d  %d  %d]\n', fsw.rw.func.PITCH_BIAS);
%     fsw.rw.func.K_KERNEL_DIRECTION   = [1 -1 -1 1];
%     fsw.rw.func.maxTorque            =  dm.rw_mdl.maxTorque;
%     fsw.rw.func.KERNEL_ANG_MOM_GAIN  = 0.01; %0.0035;
%     [orbit_period, ~]   = GetOrbitTimeAndVelocity(600);
%     orbital_pulsation                = 2 * pi/orbit_period;
%     fsw.rw.func.off_load_ctrl_gain   = 3 * orbital_pulsation;
%     fsw.rw.func.h_ref                = [0,0,0]';
%     
%   
%     %% FSW RLPD Control Parameters
%     fsw.RLPD.settleTime = 180; %(second)
%     fsw.RLPD.wn = 4 / (fsw.RLPD.settleTime*zeta);
%     fsw.RLPD.kd = 2 * zeta * fsw.RLPD.wn * diagMOI;
%     fsw.RLPD.kp = (fsw.RLPD.wn^2 * diagMOI)./ fsw.RLPD.kd ;
%     
%     
%     %% FSW ASH Control Processing
%     fsw.bdot_period        = 10; %in sec
%     fsw.bdot_gain          = 0.7;%
%     fsw.ash_mgr.Tstab = 8000;
%     fsw.ash_mgr.Tcon = 100/fsw.dt;
%     fsw.ash_mgr.epsilon = 0.001;
%     
%     % MTQ Paramters
%     fsw.mtq.func.max_dipole = 30;
%     fsw.mtq.func.Count_stab = 0; % check
%     fsw.mtq.func.Stabilized = 0; % check
%     fsw.wXbdot_gain          = 28 * 500;%
% 
%     %% FSW routing indexes
%     fsw.nav.idx.orbPulse = 1:3;
%     fsw.nav.idx.qi2l     = fsw.nav.idx.orbPulse(end)+(1:4);
%     fsw.iae.idx.qi2b     = 1:4;
%   
%     
% end

function mdl = set_model_control()
%% MDL Enables
    mdl.sim_model = 'B5G_SIM_PDR_ASH'; 
    fprintf('\nTurn off SS noise model\n');
    mdl.mode_flag = 1; % 1==ASH    0==NM
    mdl.Fs2GapSup = 1; % 1== RateBias 0== BangBang
    mdl.SupMode   = 3; % 1:Tradional, 2:Zero-Z Rot, 3:DirCos
    mdl.SunCapMode = 1; % 0=Bdot only; 1=Bdot to TAPD

    % STK control
    mdl.STKAddSat = 1; %add a satellite by 'copy and paste'
    
    mdl.Enables.dist      = 1;  % enable disturbance 
    mdl.Enables.ext_trq   = 1;
    mdl.Enables.mtq_drive = 1;
    mdl.Enables.rw_drive  = 1;
    mdl.Enables.stk_log   = 0;
   
    
%     if mdl.CloseBeforeSim
%        shh = get(0,'ShowHiddenHandles');
%        set(0,'ShowHiddenHandles','On');
%        hscope = findobj(0,'Type','Figure','Tag','SIMULINK_SIMSCOPE_FIGURE');
%        close(hscope);
%        set(0,'ShowHiddenHandles',shh);
%        Simulink.sdi.close;
%     end
end


    

