
function fsw_update = GuidanceWmaxAmax(dm0, fsw0, prj)
%-------------------------------------------------------------------------------
%   Calculate Wmax Amax for Guidance
%-------------------------------------------------------------------------------
%   Form:
%   by Jack 7/14 2022 for FS-9 MDR
%-------------------------------------------------------------------------------
%%

dm   = dm0;
fsw  = fsw0;
Isat = fsw.EstIb;
G    = fsw.rw.func.G;
D    = fsw.rw.func.D;
%%
if ~isfield(fsw,'DeltaTalloc')
    fsw.DeltaTalloc = 0.18;% by tunning
end
%%
%Angular Momentum kernel
AngMomKernel = fsw.rw.func.KERNEL_ANG_MOM_REF;    
 
%Maximum reaction wheel capacity
MaxRwAngMomCapacity = dm.rw_mdl.avlAngMom; %Nms
 
 % 1.2 20% uncertainty of MOI
mu_e        = 3.986004418e14;  
semi_mjr = norm(dm.init_pv_eci(1:3));
orbitRate = sqrt(mu_e / semi_mjr^3);
InitialScAngMom = max(abs(G(:)))*max(max(Isat))*orbitRate;
 
%Total initial angular momentum from RW offloading analysis
Hto     = 0.3;  % Nms from offloading report
Hmargin = 0.8;  % for uncertainty one tenth of Hrw_max = 8 Hms 2023/08/28

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
WmaxSingle = min(min((DeltaHalloc./a)*[1 0 0]',[],2));
WmaxDouble= min(min((DeltaHalloc./a)*[1 1 0]'/sqrt(2),[],2));
Wthd = 1.607*pi/180;
fsw.Wmax = min([fsw.Wmax Wthd]);
Tfull_sat  = 4*abs(dm.D(:,1))*dm.rw_mdl.maxTorque;
Talloc_sat = 4*abs(dm.D(:,1))*fsw.DeltaTalloc;
Hinit = round(InitialScAngMom, 2) + Hto;
% Tpert2SingleAxisX = abs(cross([fsw.Wmax 0 0],ones(3,1)* Hinit));
% Tpert2DoubleAxis = abs(cross([1 1 0]*sqrt(fsw.Wmax),ones(3,1)* Hinit));

Tpert2SingleAxisX = abs(cross([WmaxSingle 0 0],ones(3,1)* Hinit));
Tpert2DoubleAxis = abs(cross([1 1 0]*WmaxDouble/sqrt(2),ones(3,1)* Hinit));

Tpert1     = round([0.21 0.06].*Talloc_sat,2);
% 21% uncertainty on principal 6% on cross inertia
Tpert2     = max([Tpert2SingleAxisX;Tpert2DoubleAxis]);
Tpert2 = Tpert2(2:3);
Tpert  = Tpert1 + repmat(Tpert2,3,1);
Tmargin = Tfull_sat-Talloc_sat-Tpert(:,1);
Tbudget = round([Tfull_sat';Tpert(:,1)'; Talloc_sat';Tmargin';...
                 (Tmargin./ Tfull_sat)'*100],4);
items={'Full torque capacity'; 'Distubing torques';...
       'Manoeuvre'; 'Margin';'% of full torque'};
var_names = {num2str(fsw.DeltaTalloc,'DeltaTalloc = %.3f Nm'),'X axis(Nm)', 'Y axis(Nm)', 'Z axis(Nm)'};
T= table(categorical(items),Tbudget(:,1), Tbudget(:,2),Tbudget(:,3),'VariableNames', var_names);
disp(T);
%%
if nargin ~=0
    TPERT=round([Tpert1;Tpert2;Tpert],3);
    items2={'Tpert1 X'; 'Tpert1 Y';'Tpert1 Z';'Tpert2'; 'Tpert  X'; 'Tpert  Y'; 'Tpert  Z'};
    var_names2 = {num2str(fsw.DeltaTalloc,'DeltaTalloc = %.3f Nm'),'on slew axis (Nm)', 'on cross axis(Nm)'};
    T2= table(categorical(items2),TPERT(:,1),TPERT(:,2),'VariableNames', var_names2);
    
    t_name    = ['./reports/guidance/' prj.name '_' prj.phase...
                 '_guidance_' char(datetime('now','Format','yyyyMMddHHmm')) ...
                  '.xlsx'];
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
    semi_mjr_km = semi_mjr/1000;
    eclipse_param = -round(sqrt(semi_mjr_km^2-6378^2),3);
    alpha_ang = round(acosd(eclipse_param/semi_mjr_km),2);
    TE = table(categorical({'Eclipse_Param (Km)';'alpha angle (deg)'}),...
         [eclipse_param;alpha_ang],'VariableNames',{'Eclipse Parameters';'Value'});
     wr_tab(TE, 'EclipseParam');
     wr_tab(table(round(G,4)),'G Matrix');
     wr_tab(table(round(D,4)),'D Matrix');
     wr_tab(table(round(Isat,2)),'Isat+20%');
    
end
%%
fsw.EclipseParam = eclipse_param;
fsw.Amax = min((fsw.DeltaTalloc./a)*180/pi,[],1);
% fsw.DeltaTalloc = DeltaTalloc;
fsw.DeltaHalloc = DeltaHalloc;
fsw.TallocMaxSc = sum(abs(D),2)*fsw.DeltaTalloc;
fsw.Tbudget = Tbudget;
fsw_update = fsw;

