clear;
% initializing
init_fs9_sim_v1_pdr;
% init_fs9_sim_v1;
%% open the model
% mdl = set_model_control('fs9_sim_sdr_v0');
% mdl = set_model_control('fs9_sim_sdr_v1');
mdl = set_model_control('fs9_sim_pdr_v0');
open_system(mdl.sim_model);

%% 01 open logging Selector-------------------------------------------
%    Simulink.SimulationData.signalLoggingSelector(mdl.sim_model);

%% run scenario
%'Guidance';%'ash';%'nm';'rw offloading';run_min_man_dur
sim_case = 'ash';%'ash Monte Carlo';%'min man';%'AOCS Budgets';%'gap_sup';%'man';
run_scenarios;

%% Create STK Scenario
% mdl.Enables.stk_log = 0;
% GenStkAttEphRev;
%%
mdl.Enables.design_description_gen = 0;
if mdl.Enables.design_description_gen
%%
design_description_gen(mdl.sim_model,'docx');
end

%% clear variables except simulation out logs
clearvars -except out fsw mdl dm stk rpt_out gap2sup_counts sup2gap_counts