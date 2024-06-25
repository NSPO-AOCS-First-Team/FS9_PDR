% % Dissipated Power at 20 degree
load('RW4fitModel__table9.mat');

tlog = @(name) out.logsout.getElement(name).Values.Time;
dlog = @(name) out.logsout.getElement(name).Values.Data;

wheel_torque_time = tlog('RwTrq4')';
wheel_torque_data = dlog('RwTrq4')';

wheel_angularmom_time = tlog('RW_h_4')';
wheel_angularmom_data = dlog('RW_h_4')';

dissipated_power = fittedmodel_RWtable9(wheel_angularmom_data, wheel_torque_data);

% Values shown are estimated from the values in Table 8. A 1σ tolerance of 2W+10% is recommended.
dissipated_power = dissipated_power + 2;

figure();
subplot(4, 1, 1)
plot(wheel_torque_time, dissipated_power(1, :), 'LineWidth', 1.5);
dim1 = [.2 .88 0 0];
str1 = sprintf( 'RW1: %5.3f Watt', mean(dissipated_power(1, :)) );
legend(str1)
ylabel('(Watt)');
axis tight;
title('Mean Dissipated Power');
grid;
subplot(4, 1, 2)
plot(wheel_torque_time, dissipated_power(2, :), 'LineWidth', 1.5);
dim2 = [.2 .66 0 0];
str2 = sprintf( 'RW2: %5.3f Watt', mean(dissipated_power(2, :)));
% annotation('textbox',dim2,'String',str1,'FitBoxToText','on');
legend(str2)
ylabel('(Watt)');
axis tight;
grid;
subplot(4, 1, 3)
plot(wheel_torque_time, dissipated_power(3, :), 'LineWidth', 1.5);
dim3 = [.2 .42 0 0];
str3 = sprintf( 'RW3: %5.3f Watt', mean(dissipated_power(3, :)) );
% annotation('textbox',dim3,'String',str1,'FitBoxToText','on');
legend(str3)
ylabel('(Watt)');
axis tight;
grid;
subplot(4, 1, 4)
plot(wheel_torque_time, dissipated_power(4, :), 'LineWidth', 1.5);
dim4 = [.2 .2 0 0];
str4 = sprintf( 'RW4: %5.3f Watt', mean(dissipated_power(4, :)));
% annotation('textbox', dim4,'String',str1,'FitBoxToText','on');
legend(str4)
xlabel('Time (sec)');
ylabel('(Watt)');
axis tight;
set(gcf,'NumberTitle','off','Name','Dissipated Power Data');
grid;