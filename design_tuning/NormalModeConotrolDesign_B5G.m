
%% 2020/9/8 update
clear;
close all;

% MDI_MOI =[5.4253934e+07  3.6063767e+04  6.5793299e+05;...
%     3.6063767e+04  7.3913830e+07  9.9246118e+05;...
%     6.5793299e+05  9.9246118e+05  6.9699614e+07];
% PDR

%% CDR 2019/10/23
% MDI_MOI_O =[9.5998130e+07 -1.0124349e+06 -1.5448843e+04;...
%     -1.0124349e+06  1.1025635e+08 -3.7865191e+05;...
%     -1.5448843e+04 -3.7865191e+05  9.9612803e+07];

% % Delta-CDR 2020/08/26 V5.4
% MDI_MOI = [ 1.0318317e+08 -1.4056654e+06 4.4226389e+05;...
%            -1.4056654e+06 1.1367079e+08 -2.0059398e+05;...
%             4.4226389e+05 -2.0059398e+05 1.0074285e+08];

% % B5G MOI(2020-12-19) Flight Direction: Axis X;
% MDI_MOI = [ 1.3810792e+08 -6.6861403e+05  6.4412306e+05;...
%            -6.6861403e+05  2.0398508e+08  3.7338598e+06;...
%             6.4412306e+05  3.7338598e+06  1.8258562e+08];
% Ixx = 1.3809063e+08;
% Iyy = 1.8196555e+08;
% Izz = 2.0462244e+08;
% Ixyz = [Ixx Iyy Izz];          
        
% B5G MOI(2020-12-19) SWAP X and Y;
MDI_MOI = [ 2.0398508e+08 -6.6861403e+05 3.7338598e+06;...
           -6.6861403e+05  1.3810792e+08 6.4412306e+05;...
            3.7338598e+06 6.4412306e+05 1.8258562e+08];        
%         
MoiMargin = 20;% x%;
plt_flg = 1;
%MOI with Uncertainty
MoiDout = CrossIneriaCheck(MDI_MOI)*(1+MoiMargin/100);
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




% %%
% factor = 2;
% ki = (gains.PD.Kp./gains.PD.Kd)/factor;
% gains.PID.Kp = gains.PD.Kp+gains.PD.Kd.*ki;
% gains.PID.Kd = gains.PD.Kd;
% gains.PID.Ki = gains.PD.Kp.*ki;
% 
% %% Andy PID
% beta = 6;             % scale factor for tuning alpha
% fc1      = 0.14;%Hz
% wc1      = 2*pi*fc1;
% zeta1    = 1/sqrt(2);
% alpha = beta*wc1;
% gains.PIDA.Kp = Ixyz*(2*zeta1*wc1*alpha + wc1^2);
% gains.PIDA.Kd = Ixyz*(alpha +2*zeta1*wc1);
% gains.PIDA.Ki = Ixyz*(alpha*wc1^2);
% 
% %%
% % fprintf('\nPD   : Kp =[%.2f %.2f %.2f]\n',gains.PD.Kp);
% % fprintf('PID  : Kp =[%.2f %.2f %.2f]\n',gains.PID.Kp);
% % fprintf('PIDA : Kp =[%.2f %.2f %.2f]\n\n',gains.PIDA.Kp);
% % 
% % fprintf('PD   : Kd =[%.2f %.2f %.2f]\n',gains.PD.Kd);
% % fprintf('PID  : Kd =[%.2f %.2f %.2f]\n',gains.PID.Kd);
% % fprintf('PIDA : Kd =[%.2f %.2f %.2f]\n\n',gains.PIDA.Kd);
% % 
% % fprintf('PD   : Ki =[%.2f %.2f %.2f]\n',0,0,0);
% % fprintf('PID  : Ki =[%.2f %.2f %.2f]\n',gains.PID.Ki);
% % fprintf('PIDA : Ki =[%.2f %.2f %.2f]\n\n',gains.PIDA.Ki);
% fprintf('\nPD   : Kp =[% 3.1f % 3.1f % 3.1f]\n',gains.PD.Kp);
% fprintf('PID  : Kp =[% 3.1f % 3.1f % 3.1f]\n',gains.PID.Kp);
% fprintf('PIDA : Kp =[% 3.1f % 3.1f % 3.1f]\n\n',gains.PIDA.Kp);
% 
% fprintf('PD   : Kd =[% 3.1f % 3.1f % 3.1f]\n',gains.PD.Kd);
% fprintf('PID  : Kd =[% 3.1f % 3.1f % 3.1f]\n',gains.PID.Kd);
% fprintf('PIDA : Kd =[% 3.1f % 3.1f % 3.1f]\n\n',gains.PIDA.Kd);
% 
% fprintf('PD   : Ki =[% 3.1f % 3.1f % 3.1f]\n',0,0,0);
% fprintf('PID  : Ki =[% 3.1f % 3.1f % 3.1f]\n',gains.PID.Ki);
% fprintf('PIDA : Ki =[% 3.1f % 3.1f % 3.1f]\n\n',gains.PIDA.Ki);
% 
% % [gains.PD.Kp;gains.PID.Kp]
% % [gains.PD.Kd;gains.PID.Kd]
% % 
% % 
% %  [gains.PID.Kp;gains.PIDA.Kp]
% %  [gains.PID.Kd;gains.PIDA.Kd]
% %  [gains.PID.Ki;gains.PIDA.Ki]
% 
% %% Create transfer functions of Plant, Controller, and close loop TF for each axis
% num_ax   = 3;
% Gp       = tf(zeros(1,num_ax));
% 
% Gc.PD    = tf(zeros(1,num_ax));
% LG.PD    = tf(zeros(1,num_ax));
% CLTF.PD  = tf(zeros(1,num_ax));
% 
% Gc.PID   = tf(zeros(1,num_ax));
% LG.PID   = tf(zeros(1,num_ax));
% CLTF.PID = tf(zeros(1,num_ax));
% 
% Gc.PIDA   = tf(zeros(1,num_ax));
% LG.PIDA   = tf(zeros(1,num_ax));
% CLTF.PIDA = tf(zeros(1,num_ax));
% 
% 
% for i=2
% %     Gp(i)      = tf(1,[Ixyz(i) 0 0],'InputDelay',1/8);
%     Gp(i)      = tf(1,[Ixyz(i) 0 0]);
%     Gc.PD(i)   = tf([gains.PD.Kd(i) gains.PD.Kp(i)],1);
%     LG.PD(i)   = series(Gc.PD(i),Gp(i));
%     CLTF.PD(i) = feedback(LG.PD(i),1);
%     
%     Gc.PID(i)   = tf([gains.PID.Kd(i) gains.PID.Kp(i) gains.PID.Ki(i)],[1 0]);
%     LG.PID(i)   = series(Gc.PID(i),Gp(i));
%     CLTF.PID(i) = feedback(LG.PID(i),1);
%     
%     Gc.PIDA(i)   = tf([gains.PIDA.Kd(i) gains.PIDA.Kp(i) gains.PIDA.Ki(i)],[1 0]);
%     LG.PIDA(i)   = series(Gc.PIDA(i),Gp(i));
% %     CLTF.PIDA(i) = feedback(LG.PIDA(i),1);
%     if(plt_flg)
% %         figure(1);
% %         step(CLTF.PID(i),CLTF.PIDA(i));grid;legend('PID','PIDA');
% %         figure(2);
% %         subplot(1,2,1);
% %         rlocus((1/gains.PID.Kd(i))*LG.PID(i));legend('PID');
% %         subplot(1,2,2);
% %         rlocus((1/gains.PIDA.Kd(i))*LG.PIDA(i));legend('PIDA');
%         figure(3);
% %         subplot(1,2,1);
%         margin(LG.PID(i));legend('PID');
%         
%         figure(4);
%         margin(LG.PD(i));legend('PD');
% %         subplot(1,2,2);
% %         margin(LG.PIDA(i));legend('PIDA');
%     end
% %      fprintf('PID BW = %.2f Hz, PIDA BW = %.2f Hz\n',...
% %                  bandwidth(CLTF.PID(i)/(2*pi)),...
% %                  bandwidth(CLTF.PIDA(i)/(2*pi)));
%      fprintf('PD   : BW = % .2f Hz\n',bandwidth(CLTF.PD(i))/(2*pi));
%      fprintf('PID  : BW = % .2f Hz\n',bandwidth(CLTF.PID(i))/(2*pi));
%      fprintf('PIDA : BW = % .2f Hz\n\n',bandwidth(CLTF.PIDA(i))/(2*pi));
%      
% 
%      
% %      pole(CLTF.PID(i))
% %      pole(CLTF.PIDA(i))
% 

%%
Idiag = diag(MoiDout)';
% BiasRate = [1.0 1.0 1.0]*0.7;% 0.8  deg/sec
[Tmax]= GuidanceWmaxAmax_B5G(MDI_MOI);
% ThetaThresholdUpperLimit = (gains.PD.Kd./gains.PD.Kp).*BiasRate;
% ThetaThresholdLowerLimit =min([ (1/4).*(((BiasRate*pi/180).^2)./(Tmax'./Idiag))*180/pi;...
%                              0.5.*(gains.PD.Kd./gains.PD.Kp).*BiasRate]);
% %%
%     fprintf('\n\n---------------- FSW Parmeters ----------------\n');
%     %NM_CTRL
%     fprintf('//@ K_DEF_NM_CTRL_PARAM: zeta = %.2f, fc = %.2fHz\n',zeta,fc);
%     fprintf('/* THETA_THRESHOLD */\n');
%     fprintf('%10.10ff, //%5.3f deg\n',min(ThetaThresholdUpperLimit)*pi/180,min(ThetaThresholdUpperLimit));
%     fprintf('/* RATE_BIAS_MAX */\n');
%     fprintf('{ { %4.5ff, %4.5ff, %4.5ff} }, //%4.5f deg \n',BiasRate*pi/180, BiasRate(1));
%     fprintf('/* RW_PROPORTIONAL_GAIN_SLOW */\n');
%     fprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PD.Kp);
%     fprintf('/* RW_DERIVATIVE_GAIN_SLOW */\n');
%     fprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PD.Kd);
%     fprintf('/* RW_PROPORTIONAL_GAIN_FAST */\n');
%     fprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PD.Kp);
%     fprintf('/* RW_DERIVATIVE_GAIN_FAST */\n');
%     fprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PD.Kd);
%     fprintf('/* RW_PID_PROPORTIONAL_GAIN */\n');
%     fprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PID.Kp);
%     fprintf('/* RW_PID_DERIVATIVE_GAIN */\n');
%     fprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PID.Kd);
%     fprintf('/* RW_PID_INTEGRAL_GAIN */\n');
%     fprintf('{ { %5.5ff, %5.5ff, %5.5ff} },\n',gains.PID.Ki);
%     
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
%     
% 
% 
% end
% 
%      disturbingTorque = 2e-4;%from disturbance report
%      fprintf('PD static_error = [%e %e %e ]deg\n',(disturbingTorque./floor(abs(gains.PD.Kd))*180/pi));
%      
%      disturbingTorque = 2e-4;%from disturbance report
%      fprintf('PID static_error = [%e %e %e ]deg\n',(disturbingTorque./floor(abs(gains.PID.Kd))*180/pi));
