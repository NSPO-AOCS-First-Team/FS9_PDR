%% B5G PDR 2022/03/13 for B5G_SIM_PDR_V1
clear; global sim_case ;
[rads2rpm, deg2rad] = sim_initials;
set_mdl_variant;
set_scenario_inc53(2);
set_dm;
mdl = set_model_control('B5G_SIM_PDR_V1');
set_fsw_common;
set_fsw_ash; 
set_fsw_nm;
%% open the model
open_system(mdl.sim_model);

%% 01 open logging Selector-------------------------------------------
% Simulink.SimulationData.signalLoggingSelector(mdl.sim_model);

%% run scenario
sim_case = 'man';%'man';%'Guidance';%'ash';%'nm';'rw offloading';
run_scenarios;
%% Create STK Scenario
mdl.Enables.stk_log = 0;
GenStkAttEphRev;
%%
mdl.Enables.design_description_gen = 0;
if mdl.Enables.design_description_gen
%%
design_description_gen(mdl.sim_model,'docx');
end

%% clear variables except simulation out logs
clearvars -except out fsw mdl dm stk rpt_out 

%%
function [rads2rpm, deg2rad] = sim_initials
addpath('./Common');
addpath('./DesignTuning');
addpath('./sim_config');
addpath('./sim_analysis');
addpath('./fsw_init');
addpath('./mdls');
addpath('./report');
addpath('./sim_scenario');
rads2rpm    = 60/(2*pi);  %rad/s to rpm
deg2rad     = pi/180;
end
