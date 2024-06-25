
%% fs2
fs2.moi   = [278 339 347];
fs2.h_max = 10;
fs2.D= [0.669132 0.689032 0.278387];
fs2.name ='FS2';
%% fs5
fs5.moi   = [120.7  219.7  216.1];
fs5.h_max = 7.5;
fs5.D= [0.4226 0.8461 0.3248];
fs5.name ='FS5';
%% fs8
fs8.moi   = [100.1  114.8  100.1];
fs8.h_max = 4;
fs8.D= [0.5446 0.7263 0.4193];
fs8.name ='FS8';
%% b5g

b5g.moi   = [132.9  204.4  197.0];
b5g.h_max = 4;
b5g.D= [0.5448 0.7262 0.4193];
b5g.name ='B5G';
%% fs9
fs9.moi   = [279.3191  624.3258  582.1011];
fs9.h_max = 4;
fs9.D= [0.669132 0.689032 0.278387];
fs9.name ='FS9';
%%
prj={fs2, fs5, fs8, b5g, fs9};
len = length(prj);
ratio_mtx      = zeros(3,len);
ratio_mtx_norm = zeros(3,len);
for i=1:len
    prj{i}.ratio = h_max_2_moi(prj{i});
    prj{i}.ratio_nrmlz = prj{i}.ratio./prj{1}.ratio;
    ratio_mtx_norm(:,i) =  prj{i}.ratio_nrmlz';
    ratio_mtx(:,i) =  prj{i}.ratio';
end

close all;

figure;
subplot(2,1,1);
bar_plot(prj, ratio_mtx_norm, 'Normalized Angular Momentum to Inertia Ratios');
subplot(2,1,2);
bar_plot(prj, ratio_mtx, 'Angular Momentum to Inertia Ratios');
ylim(gca,[0 0.15]);

function bar_plot(prj, barmtx, tlt_str)
%     figure;
    len = length(prj);
    X = categorical({'X-Axis','Y-Axis','Z-Axis'});
    %X = reordercats(X,{'x','y','z'});
    b=bar(X,barmtx);
    
    for i=1:len
        xtips1 = b(i).XEndPoints;
        ytips1 = b(i).YEndPoints;
      
        text(xtips1,ytips1,prj{i}.name,'HorizontalAlignment','center',...
            'VerticalAlignment','bottom');
    end
    title(tlt_str);
end


%%
function ratio = h_max_2_moi(prj)
    ratio = (prj.D*4*prj.h_max )./prj.moi;
end