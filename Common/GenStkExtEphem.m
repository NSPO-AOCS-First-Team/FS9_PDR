function stk_app = GenStkExtEphem(SRC)

%%
epoch      = SRC.start_utc_epoch;
duration   = SRC.duration;
ephem_file = SRC.ephem_file;
try
    % Grab an existing instance of STK
    stk_app = actxGetRunningServer('STK11.application');
catch
    % STK is not running, launch new instance
    % Launch a new instance of STK and grab it
    stk_app = actxserver('STK11.application');
end

root            = stk_app.Personality2;
stk_app.visible = 1;
% logscale = 10^5.7;

[~,name,~] = fileparts(ephem_file);
SatelliteName = name;
EphemerisName = ephem_file;
epochSTK      = datestr(epoch,'dd mmm yyyy HH:MM:SS.000');
%%
% Create a new scenario and specify the time
try
    root.CloseScenario();
    root.NewScenario(SatelliteName);
catch
    root.NewScenario(SatelliteName);
end


% Set Scenario time
root.CurrentScenario.SetTimePeriod(epochSTK, strcat('+',num2str(duration),' sec'));
root.Rewind;

path = pwd;
%%
satNSPO = root.CurrentScenario.Children.New('eSatellite',SatelliteName);
root.ExecuteCommand('SetAnimation * TimeStep 1');
root.ExecuteCommand(strcat('SetState */Satellite/',SatelliteName,' FromFile "',path,'\',EphemerisName,'"'));                                                                       
propagator = satNSPO.Propagator;
propagator.Propagate;

