function [rsun] = SunVectorV2 ( jd )

        twopi      =     2.0*pi;
        deg2rad    =     pi/180.0;      
        tut1= ( jd - 2451545.0  )/ 36525.0;


        meanlong= 280.460  + 36000.77*tut1;
        meanlong= rem( meanlong,360.0  );  %deg

        ttdb= tut1;
        meananomaly= 357.5277233  + 35999.05034 *ttdb;
        meananomaly= rem( meananomaly*deg2rad,twopi );  %rad
        if ( meananomaly < 0.0  )
            meananomaly= twopi + meananomaly;
        end

        eclplong= meanlong + 1.914666471 *sin(meananomaly) ...
                    + 0.019994643 *sin(2.0 *meananomaly); %deg
        eclplong= rem( eclplong,360.0  );  %deg

        obliquity= 23.439291  - 0.0130042 *ttdb;  %deg

        eclplong = eclplong *deg2rad;
        obliquity= obliquity *deg2rad;

        rsun = [ cos( eclplong ); cos(obliquity)*sin(eclplong);...
                sin(obliquity)*sin(eclplong)];
