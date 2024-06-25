%% calculate beta angle

tlog = @(name) out.logsout.getElement(name).Values.Time;
dlog = @(name) out.logsout.getElement(name).Values.Data;
t_sim  = tlog('pvt_eci_nav');
pv_eci = dlog('pvt_eci_nav');
sv_eci = dlog('SunVeci');

len = length(t_sim);

beta_ang = zeros(len,1);

for i=1:len
    p = pv_eci(i,1:3);
    v = pv_eci(i,4:6);
    orb_v = cross(p, v);
    orb_v = orb_v/norm(orb_v);
    beta_ang(i,1) = 90-acosd(dot(sv_eci(i,:),orb_v));
end
%%
figure;plot(t_sim, beta_ang);grid;title('beta angle');ylabel('deg');
xlabel('Epoch Second');
