function GenStkAttFileFromSimOut( date_vector, t_sim, trueQECI2Body,fn)
%%2020/02/25
if nargin <4
    fn = 'fs7_aocs_sim_quat.a';
else
    fn = strcat(fn,'_quat.a');
end
disp(strcat('Generate STK attiude file for ', fn));

epoch = datestr(date_vector,'dd mmm yyyy HH:MM:SS.000');

trueQECI2Body = trueQECI2Body';
t   = t_sim';
len = size(trueQECI2Body,2);
fid = fopen(fn,'w');
fprintf(fid, 'stk.v.7.0\n');
fprintf(fid, 'BEGIN Attitude\n');
fprintf(fid, 'NumberOfAttitudePoints      %d\n',len);
fprintf(fid, 'BlockingFactor              20\n');
fprintf(fid, 'InterpolationOrder           1\n');
fprintf(fid, 'CentralBody Earth\n');
fprintf(fid, 'ScenarioEpoch               %s\n',epoch);
fprintf(fid, 'CoordinateAxes J2000\n');
fprintf(fid, 'AttitudeTimeQuaternions\n');
for i=1:len
    fprintf(fid,'%e %e %e %e %e\n', t(1,i), ...
        trueQECI2Body(2,i), trueQECI2Body(3,i), trueQECI2Body(4,i), trueQECI2Body(1,i));
end
fprintf(fid, 'END Attitude\n');
fclose(fid);
