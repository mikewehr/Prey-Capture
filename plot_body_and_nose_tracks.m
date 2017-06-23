filename='7520_june16_session1_arenas_1_arena 1_frames_1_11017_result_2.mat        ';
path=    'C:\Users\lab\Desktop\Prey Capture\Crickets and Sounds\June 16 Trials (All Real Sounds)\7520\results';

try
    cd(path)
    load(filename)
catch
    [filename, path] = uigetfile('*.mat', 'please select results file');
    cd(path)
    load(filename)
end
idx=strfind(filename, 'arena')
idx=idx(1)-1;
name=filename(1:idx);


xy_body=(Res.pD.final_body_positions); %body
xy_nose=(Res.pD.final_nose_positions); %nose

%plot xy tracks

figure
hold on
title(['body' name], 'interpreter', 'none')
%all tracks in background
grey=[.8 .8 .8];
plot( xy_body(:,1), xy_body(:,2), 'color', 'k')
axis equal
set(gca, 'ydir', 'reverse')

figure
hold on
title(['nose' name], 'interpreter', 'none')
%all tracks in background
grey=[.8 .8 .8];
plot( xy_nose(:,1), xy_nose(:,2), 'color', 'k')
axis equal
set(gca, 'ydir', 'reverse')

figure
plot(Res.pD.final_mouse_angles)