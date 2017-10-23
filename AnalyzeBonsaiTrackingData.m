% AnalyzeBonsaiTrackingData

% dataroot='/Volumes/C/Users/lab/Desktop/Prey Capture/Bonsai Tracking Data/';
datapath=    'C:\Users\lab\Desktop\826 mice bonsai\cage 6\RT\Good videos RT';
if ismac
    datapath= strrep(datapath, '\', '/');
    datapath= strrep(datapath, 'C:', '/Volumes/C');
end

%datapath='MAtlab videos';
%filename='data2017-07-27T14_36_50.txt';
%filename='data2017-07-27T15_58_42.txt';
filename='data2017-10-11T12_03_04.txt';
% filename= 'RT810T1.txt';

out=LoadBonsaiTracks(datapath, filename);



mouseCOMxy=out.mouseCOMxy;
mouseNosexy=out.mouseNosexy;
cricketxy=out.cricketxy;
framerate=30; 

% trim
% start=1; %seconds
% start_frame=start*framerate;
stop_frame= 450 ;
stop_frame=length(out.mouseCOMxy); %to use whole video
start_frame=1;

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
title('cleand cricket tracks')
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

figure
plot(smouseCOMx, smouseCOMy)
title('mouse COM, smoothed')
set(gca, 'ydir', 'reverse')


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
xlabel('frames')
ylabel('azimuth in degrees')
title('comparison of 2 azimuth computations')
legend('azimuth (COM-to-cricket)', 'azimuth (nose-to-cricket)')

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
plot(tspeed, 100*speed, t, range, t, azimuth) %weird because they are different units 
legend('speed', 'range', 'azimuth')

figure
plot(speed, range(2:end))
xlabel('speed')
ylabel('range')
title('range vs. speed')

figure
plot(range, azimuth, '.')
xlabel('range, pixels')
ylabel('azimuth, degrees')
title('azimuth vs. range')


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









