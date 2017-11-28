function AnalyzeBonsaiTrackingData(datapath, start_frame, stop_frame)
close all

if nargin==0
    datapath=    'C:\Users\lab\Desktop\826 mice bonsai\Cage5\lb\New folder';
    start_frame=1;
    stop_frame=[];
    
end
    
%adjust filenames to work on a mac
  if ismac
    datapath= strrep(datapath, '\', '/');
    datapath= strrep(datapath, 'C:', '/Volumes/C');
end

%datapath='MAtlab videos';
%filename='data2017-07-27T14_36_50.txt';
%filename='data2017-07-27T15_58_42.txt';

% filename='data2017-10-11T12_03_04.txt';
%filename='data2017-10-27T13_07_35.txt';

out=LoadBonsaiTracks(datapath);

if isempty(stop_frame)
    stop_frame=length(out.mouseCOMxy); %to use whole video
end

mouseCOMxy=out.mouseCOMxy;
mouseNosexy=out.mouseNosexy;
cricketxy=out.cricketxy;
framerate=30; 

% trim
% start=1; %seconds
% start_frame=start*framerate;
% stop_frame= round(9*30) ;

mouseCOMxy=mouseCOMxy(start_frame:stop_frame,:);
mouseNosexy=mouseNosexy(start_frame:stop_frame,:);
cricketxy=cricketxy(start_frame:stop_frame,:);

t=1:length(mouseCOMxy);
t=t/framerate; % t is in seconds


figure
plot(mouseCOMxy(:,1), mouseCOMxy(:,2))
%title('mouse COM')
hold on
plot(mouseNosexy(:,1), mouseNosexy(:,2))
%title('mouse Nose')
plot(cricketxy(:,1), cricketxy(:,2))
title('raw data')
legend('mouse COM', 'mouse nose', 'cricket')



% clean up cricket tracks (in 2D)
dfc1=diff(cricketxy);
thresh=10; %plausible cricket jump threshold
errframes1=find(abs(dfc1)>thresh);
clean_cricketxy=cricketxy;
for ef=errframes1'
    if ef>3 & ef<length(cricketxy)-3
        clean_cricketxy(ef,:)=median(cricketxy(ef-3:ef+3,:));
    end
end

% repeat
dfc2=diff(clean_cricketxy);
errframes2=find(abs(dfc2)>thresh);
clean2_cricketxy=clean_cricketxy;
for ef=errframes2'
    if ef>3 & ef<length(cricketxy)-3
        clean2_cricketxy(ef,:)=median(clean_cricketxy(ef-3:ef+3,:));
    end
end



% figure
% hold on
% plot(dfc1, 'o-')
% plot(errframes1,dfc1(errframes1), 'r*')
% xlim([200 300])

%how good a job did we do cleaning cricket tracks?
figure
subplot(211)
title('original vs. cleaned cricket tracks')
hold on
plot(t, cricketxy(:,1), 'o-')
plot(t, clean_cricketxy(:,1), 'go-')
plot(t, clean2_cricketxy(:,1), 'ro-')
ylabel('cricket x-pos')
legend('original', 'first pass', 'second pass')
subplot(212)
hold on
plot(t, cricketxy(:,2), 'o-')
plot(t, clean_cricketxy(:,2), 'go-')
plot(t, clean2_cricketxy(:,2), 'ro-')
ylabel('cricket y-pos')
xlabel('time, s')

figure
hold on
title('cleaned cricket tracks')
plot(cricketxy(:,1), cricketxy(:,2), 'g')
plot(clean2_cricketxy(:,1), clean2_cricketxy(:,2))
legend('original', 'cleaned')
set(gca, 'ydir', 'reverse')

%%%%%





%smooth
% 
[b,a]=butter(1, .25);
smouseCOMx=filtfilt(b,a,mouseCOMxy(:,1));
smouseCOMy=filtfilt(b,a,mouseCOMxy(:,2));
smouseNosex=filtfilt(b,a,mouseNosexy(:,1));
smouseNosey=filtfilt(b,a,mouseNosexy(:,2));
scricketx=filtfilt(b,a,clean2_cricketxy(:,1));
scrickety=filtfilt(b,a,clean2_cricketxy(:,2));


% smouseNosex=conv(mouseNosexy(:,1), g, 'same');
% smouseNosey=conv(mouseNosexy(:,2), g, 'same');
% scricketx=conv(cricketxy(:,1), g, 'same');
% scrickety=conv(cricketxy(:,2), g, 'same');

ftracks=figure('position', [418        1         788        1069]);
%subplot(311)
           ax= axes('pos', [0.1300    0.7093    0.52    0.22]);
hold on
plot(smouseCOMx, smouseCOMy, smouseNosex, smouseNosey, scricketx, scrickety)
title('mouse & cricket positions, smoothed')
set(gca, 'ydir', 'reverse')

% animate the mouse and cricket
% if(1)
%     h=plot(smouseCOMx(1), smouseCOMy(1), 'bo', smouseNosex(1), smouseNosey(1), 'ro');
%     for f=1:length(smouseCOMx)
%         hnew=plot(smouseCOMx(f), smouseCOMy(f), 'bo', ...
%             smouseNosex(f), smouseNosey(f), 'ro', ...
%             scricketx(f), scrickety(f), 'ko');
%         set(h, 'visible', 'off');
%         h=hnew;
%         pause(.01)
%     end
% end

%atan2d does the full circle (-180 to 180)
%atand does the half circle (-90 to 90)


%mouse bearing: mouse body-to-nose angle, in absolute coordinates
deltax=smouseNosex-smouseCOMx;
deltay=smouseNosey-smouseCOMy;
 mouse_bearing=atan2d(deltay, deltax);
%mouse_bearing=atand(deltay./deltax);

%mouseCOM-to-cricket angle, in absolute coordinates
deltax_ccom=scricketx-smouseCOMx;
deltay_ccom=scrickety-smouseCOMy;
 cricket_angle_com=atan2d(deltay_ccom, deltax_ccom);
%cricket_angle_com=atand(deltay_ccom./ deltax_ccom);

%mouseNose-to-cricket angle, in absolute coordinates
%(should be nearly identical to mouseCOM-to-cricket angle)
deltax_cnose=scricketx-smouseNosex;
deltay_cnose=scrickety-smouseNosey;
 cricket_angle_nose=atan2d(deltay_cnose, deltax_cnose);
%cricket_angle_nose=atand(deltay_cnose./ deltax_cnose);

%azimuth: relative angle between mouse bearing and mouseCOM-to-cricket angle
azimuth2=mouse_bearing-cricket_angle_com;
azimuth=mouse_bearing-cricket_angle_nose;

figure
hold on
plot(cricket_angle_com)
plot(cricket_angle_nose)
plot(mouse_bearing)
title('absolute angles')
legend('mouse COM to cricket', 'mouse nose to cricket', 'mouse bearing')

mouse_bearing_unwrapped = 180/pi * unwrap(mouse_bearing * pi/180);
cricket_angle_com_unwrapped = 180/pi * unwrap(cricket_angle_com * pi/180);
cricket_angle_nose_unwrapped = 180/pi * unwrap(cricket_angle_nose * pi/180);

azimuth4=mouse_bearing_unwrapped-cricket_angle_com_unwrapped;
azimuth3=mouse_bearing_unwrapped-cricket_angle_nose_unwrapped;

% fangles=figure;
figure(ftracks)
subplot(312)
hold on
plot(cricket_angle_com_unwrapped)
plot(cricket_angle_nose_unwrapped)
plot(mouse_bearing_unwrapped, 'k')
title('unwrapped absolute angles')
% legend('mouse COM to cricket', 'mouse nose to cricket', 'mouse bearing')

% animate the mouse and cricket
% if(1)
%     h=plot(smouseCOMx(1), smouseCOMy(1), 'bo', smouseNosex(1), smouseNosey(1), 'ro');
%     for f=1:length(smouseCOMx)
%         hnew=plot(smouseCOMx(f), smouseCOMy(f), 'bo', ...
%             smouseNosex(f), smouseNosey(f), 'ro', ...
%             scricketx(f), scrickety(f), 'ko');
%         set(h, 'visible', 'off');
%         h=hnew;
%         pause(.01)
%     end
% end

figure;
plot(azimuth)
hold on
plot(azimuth2)
plot(azimuth3)
plot(azimuth4)
xlabel('frames')
ylabel('azimuth in degrees')
title('comparison of 2 azimuth computations')
legend('azimuth (COM-to-cricket)', 'azimuth (nose-to-cricket)', 'unwrapped (COM-to-cricket)', 'unwrapped (nose-to-cricket)')

% fazimuth=figure;
figure(ftracks)
subplot(313)
hold on
plot(azimuth3)
xlabel('frames')
ylabel('azimuth in degrees')
title(' azimuth (nose-to-cricket, unwrapped)')
if exist('analysis_plots.ps')==2
    print -dpsc2 'analysis_plots.ps' -append -bestfit
else
    print -dpsc2 'analysis_plots.ps' -bestfit
end
line(xlim, [0 0], 'linestyle', '--')

%animate the mouse and cricket, along with angles, write to video
if 1
    [p, f, e]=fileparts(datapath);

    vidfname=sprintf('%s.avi', f);
    v=VideoWriter(vidfname);
    open(v);
    figure(ftracks)
    axes(ax) %     subplot(311)
    h=plot(smouseCOMx(1), smouseCOMy(1), 'bo', smouseNosex(1), smouseNosey(1), 'ro',scricketx(1), scrickety(1), 'ko');
legend('mouse COM', 'mouse nose', 'cricket','mouse COM', 'mouse nose', 'cricket', 'Location', 'EastOutside')
    %     figure(fangles)
    subplot(312)
    h2=plot(1,cricket_angle_nose_unwrapped(1), 'ko', 1, mouse_bearing_unwrapped(1), 'ro');
    %     figure(fazimuth)
    subplot(313)
    h3=plot(azimuth3(1), 'bo');
    
    wb=waitbar(0, 'building animation');
    for f=1:length(smouseCOMx)
        waitbar(f/length(smouseCOMx), wb);
        axes(ax)
        %subplot(311) %figure(ftracks)
%         hnew=plot(smouseCOMx(f), smouseCOMy(f), 'bo', ...
%             smouseNosex(f), smouseNosey(f), 'ro', ...
%             scricketx(f), scrickety(f), 'ko');
%         set(h, 'visible', 'off');
%         h=hnew;
        set(h(1), 'xdata', smouseCOMx(f), 'ydata', smouseCOMy(f))
        set(h(2), 'xdata', smouseNosex(f), 'ydata', smouseNosey(f))
        set(h(3), 'xdata', scricketx(f), 'ydata', scrickety(f))
        
        
        subplot(312) %figure(fangles)
        hnew2=plot(f, cricket_angle_nose_unwrapped(f), 'ko', f, mouse_bearing_unwrapped(f), 'ro');
        set(h2, 'visible', 'off');
        h2=hnew2;
        
        subplot(313) %figure(fazimuth)
        hnew3=plot(f, azimuth3(f), 'bo');
        set(h3, 'visible', 'off');
        h3=hnew3;
        
        drawnow
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
    close(v)
    close(wb)
end

%range (distance to target)
range=sqrt(deltax_cnose.^2 + deltay_cnose.^2);

%mouse speed
speed=sqrt(diff(smouseCOMx).^2 + diff(smouseCOMx).^2);
[b,a]=butter(1, .01);
speed=filtfilt(b,a,speed);
tspeed=t(2:end);
figure
plot(tspeed, speed)
xlabel('time, s')
ylabel('speed, px/s')
title('mouse speed vs. time')

figure
title('range, azimuth, and speed over time (mismatched units')
plot(tspeed, 100*speed, t, range, t, azimuth3) %weird because they are different units 
legend('speed', 'range', 'azimuth')
xlabel('time, s')
ylabel('speed, px/s')
print -dpsc2 'analysis_plots.ps' -append

figure
plot(speed, range(2:end), 'k')
hold on
numframes=length(speed);
cmap=colormap;
for j=1:3; cmap2(:,j)=interp(cmap(:,j), ceil(numframes/64));end
cmap2(find(cmap2>1))=1;
for f=1:numframes
    plot(speed(f), range(1+f), '.', 'color', cmap2(f,:))
end
text(speed(1), range(2), 'start')
text(speed(end), range(end), 'end')
    xlabel('speed')
ylabel('range')
title('range vs. speed')
print -dpsc2 'analysis_plots.ps' -append

figure
plot(range, azimuth, '.')
xlabel('range, pixels')
ylabel('azimuth, degrees')
title('azimuth vs. range')
print -dpsc2 'analysis_plots.ps' -append


% %plotting a specific window in time
% figure
% clf
% region=500:1500;
% plot(smouseCOMx(region), smouseCOMy(region), 'b', smouseNosex(region), smouseNosey(region), 'r', scricketx(region), scrickety(region), 'g')
% 
% hold on
% for r=100:100:1000
%     line([smouseCOMx(r) smouseCOMx(r)+deltax(r)], [smouseCOMy(r) smouseCOMy(r)+deltay(r)])
%     fprintf('\ndeltax: %.1f, deltay: %.1f, angle: %.1f', deltax(r), deltay(r), atan2d(deltay(r),deltax(r)))
% end

%




% need to filter out (0,0) points









