function [A, B] =  pv_time_match(A0,B0)
%% 2020/06/21 by Jack

%%Initialize
A = A0;
B = B0;

[C,ia,ib] = intersect(A0.utcsec,B0.utcsec);

utc_epoch_sec = double(C(1))/86400 + datenum([1980 1 6 0 0 0]);
dt_str_epoch  = datetime(utc_epoch_sec,'ConvertFrom','datenum');

A.start_utc_epoch = datevec(dt_str_epoch);
B.start_utc_epoch = A.start_utc_epoch;

A.utcsec_from_gps_start = C(1);
B.utcsec_from_gps_start = C(1);

A.time     = C-C(1);
B.time     = A.time;
A.duration = length(A.time);
B.duration =  A.duration;
A.date_str =  datestr(A.start_utc_epoch,'yyyy_mmm_dd');
B.date_str =  datestr(B.start_utc_epoch,'yyyy_mmm_dd');

if isfield(A0, 'ecf')
    A.ecf.pv = A0.ecf.pv(ia,:);
    B.ecf.pv = B0.ecf.pv(ib,:);
end

if isfield(A0, 'eci')
    A.eci.pv = A0.eci.pv(ia,:);
end

if isfield(B0, 'eci')
    B.eci.pv = B0.eci.pv(ib,:);
end