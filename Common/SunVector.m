function SunEci = SunVector(jD)
Ttt = JDCentury(jD); %%terrestrial time
bias = -2.872e-1;
lamda_mean     = rem(280.460+bias+36000.771*Ttt,360);
mean_anomaly   = rem(357.5291092+35999.05034*Ttt,360);
lamda_ecliptic = lamda_mean+ 1.914666471*sind(mean_anomaly)...
                 + 0.019994643*sind(2*mean_anomaly);
% Obliquity of ecliptic
% rSun = 1.000140612 - 0.016708617*cosd(mean_anomaly)-0.000139589*cosd(2*mean_anomaly);
epsilon = 23.439291 -0.0130042*Ttt;
% au = 149597871; % 1AU = 149 597 871 km
SunEci  = [cosd(lamda_ecliptic);...
           cosd(epsilon)*sind(lamda_ecliptic);...
           sind(epsilon)*sind(lamda_ecliptic)];
       
% SunEci  = [rSun*cosd(lamda_ecliptic);...
%            rSun*cosd(epsilon)*sind(lamda_ecliptic);...
%            rSun*sind(epsilon)*sind(lamda_ecliptic)];
% SunEci = SunEci * au; % unit: km     
%in ECI J2000