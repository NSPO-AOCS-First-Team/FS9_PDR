
%% 2020/9/8 update
% clear; clc;
% close all;

%% B5G MOI(2020-12-24) Flight Direction: Axis X;
        
plt_flg = 1;
%MOI with Uncertainty, MoI Margin 20% is added in init file
MoiDout = CrossIneriaCheck(dm.Ib);

Ixx = MoiDout(1,1);
Iyy = MoiDout(2,2);
Izz = MoiDout(3,3);
Ixyz = [Ixx Iyy Izz];

%
fc      = 0.10;%Hz
zeta    = 1/sqrt(2);
wc      = 2*pi*fc;

gains.PD.Kp = Ixyz*wc^2;
gains.PD.Kd = Ixyz*2*zeta*wc;

fprintf('\nPD   : Kp =[% 3.1f % 3.1f % 3.1f]\n',gains.PD.Kp);
fprintf('PD   : Kd =[% 3.1f % 3.1f % 3.1f]\n',gains.PD.Kd);


%%
Idiag = diag(MoiDout)';
[DeltaHalloc,DeltaTalloc]= GuidanceWmaxAmax_B5G(dm.Ib,theta,phi,dm)

% clearvars -except DeltaHalloc DeltaTalloc gains