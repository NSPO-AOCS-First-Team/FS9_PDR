function GenStkEphFileFromSimOut(date_vector, t_sim,  PV_ECI,fn)
%%2020/02/25
if nargin <4
    fn = 'fs7_aocs_sim_ephem.e';
else
    fn = strcat(fn,'_ephem.e');
end
disp(strcat('Creating STK Ephemeris File for ', fn));


P_ECI = PV_ECI(:,1:3);
V_ECI = PV_ECI(:,4:6);
epoch = datestr(date_vector,'dd mmm yyyy HH:MM:SS.000');
t   = t_sim';
len = size(P_ECI,1);
fid = fopen(fn,'w');
fprintf(fid, 'stk.v.7.0\n');
fprintf(fid, 'BEGIN Ephemeris\n');
fprintf(fid, 'NumberOfEphemerisPoints %d\n',len);
fprintf(fid, 'ScenarioEpoch %s\n',epoch);
fprintf(fid, 'InterpolationMethod Lagrange\n');
fprintf(fid, 'InterpolationOrder 5\n');
fprintf(fid, 'DistanceUnit Meters\n');
fprintf(fid, 'CentralBody Earth\n');
fprintf(fid, 'CoordinateSystem J2000\n');
fprintf(fid, 'EphemerisTimePosVel\n');

for i=1:len
      fprintf(fid,'%e %e %e %e %e %e %e\n', t(i), ...
            P_ECI(i,1:3),V_ECI(i,1:3));
end
fprintf(fid, 'END Ephemeris\n');
fclose(fid);
