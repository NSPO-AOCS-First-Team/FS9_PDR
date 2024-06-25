
function GuidanceWmaxAmax_B5G(~)
global dm fsw
%-------------------------------------------------------------------------------
%   Calculate Wmax Amax for Guidance
%-------------------------------------------------------------------------------
%   Form:
%   by Jack 25th March 2022 for B5G PDR
%-------------------------------------------------------------------------------
%%
Isat = fsw.EstIb;
G    = fsw.rw.func.G;
D    = fsw.rw.func.D;
%%
DeltaTalloc = 0.178;% Nm DeltaTalloc is a guass from 0.25 and decrease to 0
%Angular Momentum kernel
AngMomKernel = fsw.rw.func.KERNEL_ANG_MOM_REF;    
 
%Maximum reaction wheel capacity
MaxRwAngMomCapacity = dm.rw_mdl.avlAngMom; %Nms
 
 % initial spacecraft angular momentum, 1.1e-3 == orbit rate
 % 1.2 20% uncertainty of MOI
mu_e        = 3.986004418e14;  
semi_mjr = norm(dm.init_pv_eci(1:3));
% orbitRate = sqrt(mu_e / (6378137 + 600000)^3);         % B5G: 600 km
orbitRate = sqrt(mu_e / semi_mjr^3);
InitialScAngMom = max(abs(G(:)))*max(max(Isat))*orbitRate;
 
%Total initial angular momentum from RW offloading analysis
Hto     = 0.3;    % Nms from offloading report
Hmargin = 0.4; % for uncertainty one tenth of Hrw_max = 4 Hms

%---------------------------------------------------------


DeltaHalloc = MaxRwAngMomCapacity - AngMomKernel - round(InitialScAngMom, 2) - Hto -Hmargin;

itemsH={'Maximum Reaction Wheel Capcity'; ...
        'Angular Momentum Kernel Used for Wheel Control';...
        'Initial Wheel Angualr Momentum due to External Torques';...
        'Worse Case of Initial Spacecraft Angular Momentum';...
        'Margin for Uncertainty';...
        'Angular Momentum Allocation on Each Wheel'};
Hbudget = round([MaxRwAngMomCapacity;AngMomKernel;Hto;InitialScAngMom;...
                Hmargin;DeltaHalloc],2);
TH= table(categorical(itemsH),Hbudget,'VariableNames', {'DeltaHalloc';'Nms'});

fsw.ctrl.HallocMaxSc4RW     = sum(abs(D),2)*DeltaHalloc;
a = abs(G*Isat);
fsw.Wmax = min(min((DeltaHalloc./a),[],2));
Wthd = 1.0*pi/180; %'1 deg/sec'
fsw.Wmax = min([fsw.Wmax Wthd]);
Tfull_sat  = 4*abs(dm.D(:,1))*dm.rw_mdl.maxTorque;
Talloc_sat = 4*abs(dm.D(:,1))*DeltaTalloc;
Hinit = round(InitialScAngMom, 2) + Hto;
Tpert2SingleAxisX = abs(cross([fsw.Wmax 0 0],ones(3,1)* Hinit));
Tpert2DoubleAxis = abs(cross([1 1 0]*sqrt(fsw.Wmax),ones(3,1)* Hinit));
Tpert1     = round([0.21 0.06].*Talloc_sat,2);
Tpert2     = max([Tpert2SingleAxisX;Tpert2DoubleAxis]);
Tpert2 = Tpert2(2:3);
Tpert  = Tpert1 + repmat(Tpert2,3,1);
Tmargin = Tfull_sat-Talloc_sat-Tpert(:,1);
Tbudget = round([Tfull_sat';Tpert(:,1)'; Talloc_sat';Tmargin';...
                 (Tmargin./ Tfull_sat)'*1000],4);
% disp(Tmargin./ Tfull_sat*1000)
items={'Full torque capacity'; 'Distubing torques';...
       'Manoeuvre'; 'Margin';'% of full torque'};
var_names = {num2str(DeltaTalloc,'DeltaTalloc = %.3f Nm'),'X axis(Nm)', 'Y axis(Nm)', 'Z axis(Nm)'};
T= table(categorical(items),Tbudget(:,1), Tbudget(:,2),Tbudget(:,3),'VariableNames', var_names);
disp(T);
%%
if nargin~=0
    TPERT=round([Tpert1;Tpert2;Tpert],3);
    items2={'Tpert1 X'; 'Tpert1 Y';'Tpert1 Z';'Tpert2'; 'Tpert  X'; 'Tpert  Y'; 'Tpert  Z'};
    var_names2 = {num2str(DeltaTalloc,'DeltaTalloc = %.3f Nm'),'on slew axis (Nm)', 'on cross axis(Nm)'};
    T2= table(categorical(items2),TPERT(:,1),TPERT(:,2),'VariableNames', var_names2);
    
    t_name    = ['./report/guidance/b5g_guidance_' ...
                 datestr(now,'yyyymmddHHMM') '.xlsx'];
    wr_tab    = @(tbl,sht_name) writetable(tbl,t_name,'Sheet',sht_name,...
                                         'WriteMode','Append');

    wr_tab(T2, 'Disturbing Torques');
    wr_tab(T, 'Torque Budget');
    wr_tab(TH, 'DeltaHalloc');
    
    MaxScRate = round(fsw.ctrl.HallocMaxSc4RW./diag(fsw.EstIb)*180/pi,2);
    itemR = {'(deg/sec)'};
    TR= table(categorical(itemR), MaxScRate(1),MaxScRate(2),MaxScRate(3),...
        'VariableNames',{'Max Possible Body Rate';'X';'Y';'Z'});
    wr_tab(TR, 'MaxScRate');
    
    eclipse_param = -round(sqrt((6378+600)^2-6378^2),3);
    alpha_ang = round(acosd(eclipse_param/(6378+600)),2);
    TE = table(categorical({'Eclipse_Param (Km)';'alpha angle (deg)'}),...
         [eclipse_param;alpha_ang],'VariableNames',{'Eclipse Parameters';'Value'});
     wr_tab(TE, 'EclipseParam');
     wr_tab(table(round(G,4)),'G Matrix');
     wr_tab(table(round(D,4)),'D Matrix');
     wr_tab(table(round(Isat,2)),'Isat+20%');
    
end
%%
fsw.Amax = min((DeltaTalloc./a)*180/pi,[],1);
fsw.DeltaTalloc = DeltaTalloc;
fsw.DeltaHalloc = DeltaHalloc;
fsw.TallocMaxSc = sum(abs(D),2)*DeltaTalloc;
 





