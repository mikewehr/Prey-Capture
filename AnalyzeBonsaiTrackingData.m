% AnalyzeBonsaiTrackingData

% dataroot='/Volumes/C/Users/lab/Desktop/Prey Capture/Bonsai Tracking Data/';
dataroot= 'C:\Users\lab\Desktop\Prey Capture\Bonsai Tracking Data';
datapath='MAtlab videos';
%filename='data2017-07-27T14_36_50.txt';
%filename='data2017-07-27T15_58_42.txt';
filename='data2017-09-01T13_06_39.txt';
% filename= 'RT810T1.txt';

out=LoadBonsaiTracks(fullfile(dataroot, datapath), filename);



mouseCOMxy=out.mouseCOMxy;
mouseNosexy=out.mouseNosexy;
cricketxy=out.cricketxy;
framerate=30*5; %because we get 5 datapoints per frame from bonsai

% trim
% start=1; %seconds
% start_frame=start*framerate;
start_frame=1;
stop_frame= 450 ;
mouseCOMxy=mouseCOMxy(start_frame:stop_frame,:);
mouseNosexy=mouseNosexy(start_frame:stop_frame,:);
cricketxy=cricketxy(start_frame:stop_frame,:);

t=1:length(mouseCOMxy);
t=t/framerate; % t is in seconds


%figure
plot(mouseCOMxy(:,1), mouseCOMxy(:,2))
title('mouse COM')
hold on
plot(mouseNosexy(:,1), mouseNosexy(:,2))
title('mouse Nose')
plot(cricketxy(:,1), cricketxy(:,2))
title('cricket')



%smooth
% 
% [b,a]=butter(1, .25);
% smouseCOMx=filtfilt(b,a,mouseCOMxy(:,1));
% smouseCOMy=filtfilt(b,a,mouseCOMxy(:,2));
% smouseNosex=filtfilt(b,a,mouseNosexy(:,1));
% smouseNosey=filtfilt(b,a,mouseNosexy(:,2));
% scricketx=filtfilt(b,a,cricketxy(:,1));
% scrickety=filtfilt(b,a,cricketxy(:,2));
% 
% 
% smouseNosex=conv(mouseNosexy(:,1), g, 'same');
% smouseNosey=conv(mouseNosexy(:,2), g, 'same');
% scricketx=conv(cricketxy(:,1), g, 'same');
% scrickety=conv(cricketxy(:,2), g, 'same');

figure
plot(smouseCOMx, smouseCOMy)
title('mouse COM')


%mouse bearing: mouse body-to-nose angle, in absolute coordinates
deltax=smouseNosex-smouseCOMx;
deltay=smouseNosey-smouseCOMy;
mouse_bearing=atan2d(deltay, deltax);

%mouseCOM-to-cricket angle, in absolute coordinates
deltax_ccom=scricketx-smouseCOMx;
deltay_ccom=scrickety-smouseCOMy;
cricket_angle_com=atan2d(deltay_ccom, deltax_ccom);

%mouseNose-to-cricket angle, in absolute coordinates
%(should be nearly identical to mouseCOM-to-cricket angle)
deltax_cnose=scricketx-smouseNosex;
deltay_cnose=scrickety-smouseNosey;
cricket_angle_nose=atan2d(deltay_cnose, deltax_cnose);

%azimuth: relative angle between mouse bearing and mouseCOM-to-cricket angle
azimuth2=mouse_bearing-cricket_angle_com;
azimuth=mouse_bearing-cricket_angle_nose;

figure
plot(azimuth)
hold on
plot(azimuth2)
title('two azimuth computations')

%range (distance to target)
range=sqrt(deltax_cnose.^2 + deltay_cnose.^2);

%speed
speed=sqrt(diff(smouseCOMx).^2 + diff(smouseCOMx).^2);
[b,a]=butter(1, .01);
speed=filtfilt(b,a,speed);
tspeed=t(2:end);
plot(tspeed, speed)

figure
plot(t, range, t, azimuth) %weird because they are different units (degrees, pixels)

figure
plot(tspeed, 100*speed, t, range, t, azimuth) %weird because they are different units 

figure
plot(speed, range(2:end))
xlabel('speed')
ylabel('range')

figure
plot(range, azimuth, '.')
xlabel('range, pixels')
ylabel('azimuth, degrees')

figure
plot(mouseCOMxy(:,1))

figure
plot(mouseCOMxy(:,1), mouseCOMxy(:,2), mouseNosexy(:,1), mouseNosexy(:,2))

figure
clf
region=500:1500;
plot(smouseCOMx(region), smouseCOMy(region), 'b', smouseNosex(region), smouseNosey(region), 'r', scricketx(region), scrickety(region), 'g')

hold on
for r=100:100:1000
    line([smouseCOMx(r) smouseCOMx(r)+deltax(r)], [smouseCOMy(r) smouseCOMy(r)+deltay(r)])
    fprintf('\ndeltax: %.1f, deltay: %.1f, angle: %.1f', deltax(r), deltay(r), atan2d(deltay(r),deltax(r)))
end






% need to filter out (0,0) points









