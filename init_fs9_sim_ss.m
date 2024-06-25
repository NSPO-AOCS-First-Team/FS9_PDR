clc;clear;

load('C:\8049\FS9\FS9_Sim_SDR_0921_for ASH DoD\models\Dss.mat')
sun_vector = [t;dss_eqpt(3:6,:)]';
alpha_y = [t;dss_func(3,:)]';
duration = 0.125*80000;
Ke = 0.02;
Kv = 6.5305;