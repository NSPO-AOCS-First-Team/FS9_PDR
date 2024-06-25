
%% 2022/7/15 update

%MDI V6.1
MDI_MOI = dm.Ib;
    

MoiMargin = 20;% x%;
plt_flg = 1;
%MOI with Uncertainty
MoiDout = CrossIneriaCheck(MDI_MOI)*(1+MoiMargin/100);
Ixx = MoiDout(1,1);
Iyy = MoiDout(2,2);
Izz = MoiDout(3,3);
Ixyz = [Ixx Iyy Izz];

%%
fc      = 0.10;%Hz
zeta    = 1/sqrt(2);
wc      = 2*pi*fc;

gains.PD.Kp = Ixyz*wc^2;
gains.PD.Kd = Ixyz*2*zeta*wc;

fprintf('\nPD   : Kp =[% 3.1f % 3.1f % 3.1f]\n',gains.PD.Kp);
fprintf('PD   : Kd =[% 3.1f % 3.1f % 3.1f]\n',gains.PD.Kd);




%%
factor = 2;
ki = (gains.PD.Kp./gains.PD.Kd)/factor;
gains.PID.Kp = gains.PD.Kp+gains.PD.Kd.*ki;
gains.PID.Kd = gains.PD.Kd;
gains.PID.Ki = gains.PD.Kp.*ki;

%% Andy PID
beta = 6;             % scale factor for tuning alpha
fc1      = 0.14;%Hz
wc1      = 2*pi*fc1;
zeta1    = 1/sqrt(2);
alpha = beta*wc1;
gains.PIDA.Kp = Ixyz*(2*zeta1*wc1*alpha + wc1^2);
gains.PIDA.Kd = Ixyz*(alpha +2*zeta1*wc1);
gains.PIDA.Ki = Ixyz*(alpha*wc1^2);

%% Create transfer functions of Plant, Controller, and close loop TF for each axis
num_ax   = 3;
Gp       = tf(zeros(1,num_ax));

Gc.PD    = tf(zeros(1,num_ax));
LG.PD    = tf(zeros(1,num_ax));
CLTF.PD  = tf(zeros(1,num_ax));

Gc.PID   = tf(zeros(1,num_ax));
LG.PID   = tf(zeros(1,num_ax));
CLTF.PID = tf(zeros(1,num_ax));

Gc.PIDA   = tf(zeros(1,num_ax));
LG.PIDA   = tf(zeros(1,num_ax));
CLTF.PIDA = tf(zeros(1,num_ax));


for i=2
%     Gp(i)      = tf(1,[Ixyz(i) 0 0],'InputDelay',1/8);
    Gp(i)      = tf(1,[Ixyz(i) 0 0]);
    Gc.PD(i)   = tf([gains.PD.Kd(i) gains.PD.Kp(i)],1);
    LG.PD(i)   = series(Gc.PD(i),Gp(i));
    CLTF.PD(i) = feedback(LG.PD(i),1);
    
    Gc.PID(i)   = tf([gains.PID.Kd(i) gains.PID.Kp(i) gains.PID.Ki(i)],[1 0]);
    LG.PID(i)   = series(Gc.PID(i),Gp(i));
    CLTF.PID(i) = feedback(LG.PID(i),1);
    
    Gc.PIDA(i)   = tf([gains.PIDA.Kd(i) gains.PIDA.Kp(i) gains.PIDA.Ki(i)],[1 0]);
    LG.PIDA(i)   = series(Gc.PIDA(i),Gp(i));
    if(plt_flg)    
        figure(3);
        margin(LG.PID(i));legend('PID');
        
        figure(4);
        margin(LG.PD(i));legend('PD');
    end

     fprintf('PD   : BW = % .2f Hz\n',bandwidth(CLTF.PD(i))/(2*pi));
     fprintf('PID  : BW = % .2f Hz\n',bandwidth(CLTF.PID(i))/(2*pi));
     fprintf('PIDA : BW = % .2f Hz\n\n',bandwidth(CLTF.PIDA(i))/(2*pi));
   
%%
Idiag = diag(MoiDout)';
BiasRate = [1.0 1.0 1.0]*0.7;% 0.8  deg/sec
[Tmax] = fsw.Amax;%GuidanceWmaxAmax(dm,fsw);
ThetaThresholdUpperLimit = (gains.PD.Kd./gains.PD.Kp).*BiasRate;
ThetaThresholdLowerLimit =min([ (1/4).*(((BiasRate*pi/180).^2)./(Tmax'./Idiag))*180/pi;...
                             0.5.*(gains.PD.Kd./gains.PD.Kp).*BiasRate]);
%%
    fprintf('\n\n---------------- FSW Parmeters ----------------\n');
    %NM_CTRL
    fprintf('//@ K_DEF_NM_CTRL_PARAM: zeta = %.2f, fc = %.2fHz\n',zeta,fc);
    fprintf('/* THETA_THRESHOLD */\n');
    fprintf('%10.10ff, //%5.3f deg\n',min(ThetaThresholdUpperLimit)*pi/180,min(ThetaThresholdUpperLimit));
    fprintf('/* RATE_BIAS_MAX */\n');
    fprintf('{ { %4.5ff, %4.5ff, %4.5ff} }, //%4.5f deg \n',BiasRate*pi/180, BiasRate(1));
    fprintf('/* RW_PROPORTIONAL_GAIN_SLOW */\n');
    fprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PD.Kp);
    fprintf('/* RW_DERIVATIVE_GAIN_SLOW */\n');
    fprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PD.Kd);
    fprintf('/* RW_PROPORTIONAL_GAIN_FAST */\n');
    fprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PD.Kp);
    fprintf('/* RW_DERIVATIVE_GAIN_FAST */\n');
    fprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PD.Kd);
    fprintf('/* RW_PID_PROPORTIONAL_GAIN */\n');
    fprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PID.Kp);
    fprintf('/* RW_PID_DERIVATIVE_GAIN */\n');
    fprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PID.Kd);
    fprintf('/* RW_PID_INTEGRAL_GAIN */\n');
    fprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PID.Ki);
    
    %NM_MGR
    fprintf('\n@ K_DEF_NM_MGR_PARAM:\n');
    fprintf('/* ECLIPSE_PARAM */\n');
    fprintf('%10.10ff,\n',fsw.EclipseParam*1e3);
    %GUID
    fprintf('\n@ K_DEF_GUID_PARAM:\n');
    fprintf('/* WHEEL_MOM_ALLOC */\n');
    fprintf('{ { %4.3ff, %4.3ff, %4.3ff, %4.3ff } },\n',repmat(fsw.DeltaHalloc,[1 4]));
    fprintf('/* WHEEL_MAX_TORQUE */\n');
    fprintf('{ { %4.3ff, %4.3ff, %4.3ff, %4.3ff } },\n',repmat(fsw.DeltaTalloc,[1 4]));   
    fprintf('/* MAN_ANG_RATE_SATU */\n');
    fprintf('%2.15ff, //%5.3f*pi/180\n',fsw.Wmax, fsw.Wmax*180/pi);
    
%     
%     str = sprintf('//@ K_DEF_NM_CTRL_PARAM: zeta = %.2f, fc = %.2fHz\n',zeta,fc);
%     str =[str sprintf('/* THETA_THRESHOLD */\n')];
%     str =[str sprintf('%10.10ff,\n',min(ThetaThresholdUpperLimit)*pi/180)];
%     str =[str sprintf('/* RATE_BIAS_MAX */\n')];
%     str =[str sprintf('{ { %4.5ff, %4.5ff, %4.5ff} },\n',BiasRate*pi/180)];
%     str =[str sprintf('/* RW_PROPORTIONAL_GAIN_SLOW */\n')];
%     str =[str sprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PD.Kp)];
%     str =[str sprintf('/* RW_DERIVATIVE_GAIN_SLOW */\n')];
%     str =[str sprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PD.Kd)];
%     str =[str sprintf('/* RW_PROPORTIONAL_GAIN_FAST */\n')];
%     str =[str sprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PD.Kp)];
%     str =[str sprintf('/* RW_DERIVATIVE_GAIN_FAST */\n')];
%     str =[str sprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PD.Kd)];
%     str =[str sprintf('/* RW_PID_PROPORTIONAL_GAIN */\n')];
%     str =[str sprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PID.Kp)];
%     str =[str sprintf('/* RW_PID_DERIVATIVE_GAIN */\n')];
%     str =[str sprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PID.Kd)];
%     str =[str sprintf('/* RW_PID_INTEGRAL_GAIN */\n')];
%     str =[str sprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PID.Ki)];
%    
%     clipboard('copy',str)
    


end

   