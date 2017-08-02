% AnalyzeBonsaiTrackingData

dataroot='/Volumes/C/Users/lab/Desktop/Prey Capture/Bonsai Tracking Data/';
datapath='RT';
%filename='data2017-07-27T11_14_46.txt';
% filename='data2017-07-27T13_18_46.txt';
filename='data2017-08-01T14_52_27.txt';


out=LoadBonsaiTracks(fullfile(dataroot, datapath), filename);



mouseCOMxy=out.mouseCOMxy;
mouseNosexy=out.mouseNosexy;
cricketxy=out.cricketxy;
t=1:length(mouseCOMxy);
framerate=30;
t=t/framerate; % t is in seconds

figure
plot(mouseCOMxy(:,1), mouseCOMxy(:,2))
title('mouse COM')
figure
plot(mouseNosexy(:,1), mouseNosexy(:,2))
title('mouse Nose')
figure
plot(cricketxy(:,1), cricketxy(:,2))
title('cricket')

%smooth
g=gaussian(10, .25);
g=g/sum(g);
smouseCOMx=conv(mouseCOMxy(:,1), g, 'same');
smouseCOMy=conv(mouseCOMxy(:,2), g, 'same');
smouseNosex=conv(mouseNosexy(:,1), g, 'same');
smouseNosey=conv(mouseNosexy(:,2), g, 'same');
scricketx=conv(cricketxy(:,1), g, 'same');
scrickety=conv(cricketxy(:,2), g, 'same');

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

%range (distance to target)
range=sqrt(deltax_cnose.^2 + deltay_cnose.^2);

figure
plot(t, range, t, azimuth) %weird because they are different units (degrees, pixels)

figure
plot(range, azimuth, '.')
xlabel('range, pixels')
ylabel('azimuth, degrees')

figure
plot(smouseCOMxy(:,1))

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









