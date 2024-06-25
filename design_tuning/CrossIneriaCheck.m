% Check if cross ineria of MOI is larger than 5% of diaganol terms


function [MOI] = CrossIneriaCheck(MOI)

% if(nargin ==0)
%     MOI =[5.4253934e+07  3.6063767e+04  6.5793299e+05;...
%     3.6063767e+04  7.3913830e+07  9.9246118e+05;...
%     6.5793299e+05  9.9246118e+05  6.9699614e+07];
%     % kg-mm^2
%     % from MDI V3.9 Deployed
% end

% Unit in kg-m^2
if(MOI(1,1)>1e4)
        MOI = MOI*1e-6;%kg-m^2
end

MOI_RATIO = zeros(3,3);
for i=1:3
    for j=1:3
        if(i~=j)
            if abs(MOI(i,j)/MOI(i,i))>abs(MOI(i,j)/MOI(j,j))
                MOI_RATIO (i,j)= abs(MOI(i,j)/MOI(i,i))*100;
            else
                MOI_RATIO (i,j)= abs(MOI(i,j)/MOI(j,j))*100;
            end
            
            if(MOI_RATIO (i,j)>5)
                fprintf('Warning cross inertia I(%d,%d) out of requirement.\n',i,j)
            end
        else
            MOI_RATIO (i,j) = (MOI(i,j)/MOI(i,j))*100;
        end
    end
end
% MOI_RATIO
% fprintf('MOI_RATIO = \n[\t%4.1f%%\t%4.1f%%\t%4.1f%%\n\t%4.1f%%\t%4.1f%%\t%4.1f%%\n\t%4.1f%%\t%4.1f%%\t%4.1f%%\t]\n',MOI_RATIO);
fprintf('[\t%-4.1f\t%4.1f\t%4.1f\n\t%4.1f\t%4.1f\t%4.1f\n\t%4.1f\t%4.1f\t%4.1f\t]%%\n',MOI_RATIO);