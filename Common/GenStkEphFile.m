function fn = GenStkEphFile(SRC, Coord)
%%2020/06/18
%%2020/6/20 Update

date_vector = SRC.start_utc_epoch;
t_sim       = SRC.time;
fn          = SRC.source;
if strcmp(Coord,'Fixed')
    PV_METER = SRC.ecf.pv;
else
    PV_METER = SRC.eci.pv;
end

if nargin <5
    fn = strcat(datestr(now,'yyyy_mm_dd_HH_MM_SS_'),'stk_ephem.e');
else
    fn = strcat(fn,'_ephem.e');
end

if nargin <4
    coord_sys = 'CoordinateSystem Fixed\n';
else
    coord_sys = char(strcat('CoordinateSystem',{' '},Coord,'\n'));
end

disp(strcat('Creating STK Ephemeris File for ', fn));


 
P_METER = PV_METER(:,1:3);
V_METER = PV_METER(:,4:6);

vnorm = norm(V_METER(1,:));
if(vnorm < 16.7) %3rd cosmic velocity km/s
    % must be km unit
    P_METER = P_METER*1e3;
    V_METER = V_METER*1e3;
end

epoch = datestr(date_vector,'dd mmm yyyy HH:MM:SS.000');
t   = t_sim';
len = size(P_METER,1);
fid = fopen(fn,'w');
fprintf(fid, 'stk.v.7.0\n');
fprintf(fid, 'BEGIN Ephemeris\n');
fprintf(fid, 'NumberOfEphemerisPoints %d\n',len);
fprintf(fid, 'ScenarioEpoch %s\n',epoch);
fprintf(fid, 'InterpolationMethod Lagrange\n');
fprintf(fid, 'InterpolationOrder 5\n');
fprintf(fid, 'DistanceUnit Meters\n');
fprintf(fid, 'CentralBody Earth\n');
fprintf(fid, coord_sys);
fprintf(fid, 'EphemerisTimePosVel\n');

for i=1:len
      fprintf(fid,'%.8e %.8e %.8e %.8e %.8e %.8e %.8e\n', t(i), ...
            P_METER(i,1:3),V_METER(i,1:3));
end
fprintf(fid, 'END Ephemeris\n');
fclose(fid);
