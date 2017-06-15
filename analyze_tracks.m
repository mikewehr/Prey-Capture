function analyze_tracks

filename='7521_trial2_day2_fakesounds_arenas_1_arena 1_frames_1_7927_result_1.mat';
path='/Volumes/C/Users/lab/Desktop/Prey Capture/Crickets and Sounds/June 9 Trials/Mouse 7521 June 9/results';
try
    cd(path)
    load(filename)
catch
    [filename, path] = uigetfile('*.mat', 'please select results file');
    cd(path)
    load(filename)
end

fprintf('\nEvents: ')
for i=1:length(Res.event_names)
    fprintf('%s ', Res.event_names{i})
end
switch Res.event_names{1}
    case 'Speaker1'
        s1all=Res.event_inds{1};
        s2all=Res.event_inds{2};
    case 'Speaker2'
        s1all=Res.event_inds{2};
        s2all=Res.event_inds{1};
    otherwise
        error(sprintf('did not recognize event %s', Res.event_names))
end

s1=[s1all(1) s1all(find(diff(s1all)>1)+1)];
s2=[s2all(1) s2all(find(diff(s2all)>1)+1)];

prewin=0;
postwin=300;

if s1(1)<prewin
    prewin=s1(1)-1;
    fprintf('\nsound presented on frame %d, changing pre-sound window to %d frames', prewin, prewin)
end
if s2(1)<prewin
    prewin=s2(1)-1;
    fprintf('\nsound presented on frame %d, changing pre-sound window to %d frames', prewin, prewin)
end

xy=(Res.pD.final_body_positions); %good
for i=1:length(s1)
    s1tracks(i,:,:)=xy(s1(i)-prewin:s1(i)+postwin,:);
end
for i=1:length(s2)
    s2tracks(i,:,:)=xy(s2(i)-prewin:s2(i)+postwin,:);
end

idx=strfind(filename, 'arena')
idx=idx(1)-1;
name=filename(1:idx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot xy tracks

figure
hold on
title(name, 'interpreter', 'none')
%all tracks in background
grey=[.8 .8 .8];
plot( xy(:,1), xy(:,2), 'color', grey)
axis equal
set(gca, 'ydir', 'reverse')

for i=1:length(s1)
    plot( s1tracks(i,:,1), s1tracks(i,:,2), 'r')
    text( s1tracks(i,1,1)+10, s1tracks(i,1,2), int2str(i), 'color', 'r')
    plot( s1tracks(i,prewin+1,1), s1tracks(i,prewin+1,2), 'k*')
%     plot( s1tracks(i,end,1), s1tracks(i,end,2), 'rx', 'markersize', 10)
    plot( s1tracks(i,end,1), s1tracks(i,end,2), 'ko', 'markersize', 10)
    text( s1tracks(i,end,1), s1tracks(i,end,2), int2str(i), 'color', 'k')
    
end
for i=1:length(s2)
    plot( s2tracks(i,:,1), s2tracks(i,:,2), 'b')
%     plot( s2tracks(i,1,1), s2tracks(i,1,2), 'ko')
    text( s2tracks(i,1,1)+10, s2tracks(i,1,2), int2str(i), 'color', 'b')

    plot( s2tracks(i,prewin+1,1), s2tracks(i,prewin+1,2), 'k*')
%     plot( s2tracks(i,end,1), s2tracks(i,end,2), 'bx', 'markersize', 10)
    plot( s2tracks(i,end,1), s2tracks(i,end,2), 'ko', 'markersize', 10)
    text( s2tracks(i,end,1), s2tracks(i,end,2), int2str(i), 'color', 'k')
end


%legend
plot(1400, 1000, 'ro')
text(1420, 1000, 'Spk1')
plot(1400, 950, 'bo')
text(1420, 950, 'Spk2')


%plot speaker location - this is hard-coded, need to update if we change
%arena or speaker
speaker1x=1e3*[    1.3869    1.3815    1.3657    1.3404    1.3076    1.2693    1.2282    1.1871    1.1489    1.1160    1.0908    1.0749    1.0695    1.0749    1.0908    1.1160    1.1489    1.1871    1.2282    1.2693    1.3076    1.3404    1.3657    1.3815    1.3869];
speaker1y=[286.4480  327.5252  365.8032  398.6732  423.8952  439.7504  445.1584  439.7504  423.8952  398.6732  365.8032  327.5252  286.4480  245.3707  207.0928  174.2228  149.0007  133.1455  127.7376  133.1455  149.0007  174.2228  207.0928  245.3707  286.4480];
speaker2x=[ 568.3122  562.9043  547.0491  521.8270  488.9570  450.6791  409.6018  368.5245  330.2466  297.3766  272.1546  256.2993  250.8914  256.2993  272.1546  297.3766  330.2466  368.5245  409.6018  450.6791  488.9570  521.8270  547.0491  562.9043  568.3122];
speaker2y=[ 815.2851  856.3623  894.6403  927.5103  952.7323  968.5875  973.9955  968.5875  952.7323  927.5103  894.6403  856.3623  815.2851  774.2078  735.9299  703.0599  677.8378  661.9826  656.5747  661.9826  677.8378  703.0599  735.9299  774.2078  815.2851];
speaker1mx=mean(speaker1x);
speaker1my=mean(speaker1y);
speaker2mx=mean(speaker2x);
speaker2my=mean(speaker2y);
plot(speaker1x, speaker1y, 'r', speaker2x, speaker2y,'b', speaker1mx, speaker1my, 'r*', speaker2mx, speaker2my,'b*' )
shg


%plot zones
% for i=1:length(Res.ZV)
%     z=Res.ZV{i}
%     plot(z(:,1), z(:,2))
% end

% figure
% xy=(Res.pD.final_nose_positions); %lots of flips
% xy=(Res.pD.final_body_positions); %good
% xy=(Res.pD.interpolated_body_position); %mostly nan
% xy=(Res.pD.interpolated_nose_position); %mostly nan
% xy=(Res.pD.user_defined_mouseCOM); %all nan
% 
% 
% plot( xy(:,1), xy(:,2))
% shg
% 
% 
% user_defined_mouse_angle
% user_defined_nosePOS
% interpolated_body_position
% interpolated_nose_position
% interpolated_mouse_angle
% final_nose_positions
% final_body_positions
% final_mouse_angles


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot speed

for i=1:length(s1)
    s1speed(i,:)=Res.smoothed_speed(s1(i):s1(i)+postwin);
end
for i=1:length(s2)
        s2speed(i,:)=Res.smoothed_speed(s2(i):s2(i)+postwin);
end

   t=1:length(s1speed);
     t=t*Res.deltaT;


figure
hold on
for i=1:length(s1)
    plot(t, s1speed(i,:), 'r')
end
for i=1:length(s2)
    plot(t, s2speed(i,:), 'b')
end
     xlabel('time, seconds')
     ylabel('speed, cm/s')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot range (distance to target)

for i=1:length(s1)
     x=s1tracks(i,:,1);
     y=s1tracks(i,:,2);
     d=sqrt((x-speaker1mx).^2 + (y-speaker1my).^2);
     d=.1*d/Res.pD.arena_data.pixels_per_mm;
     s1distance(i,:)=d;
end
for i=1:length(s2)
     x=s2tracks(i,:,1);
     y=s2tracks(i,:,2);
     d=sqrt((x-speaker2mx).^2 + (y-speaker2my).^2);
     d=.1*d/Res.pD.arena_data.pixels_per_mm;
     s2distance(i,:)=d;
end

   figure
   t=1:length(d);
     t=t*Res.deltaT;
     plot(t, s1distance, 'r', t, s2distance, 'b')
     xlabel('time, seconds')
     ylabel('distance to target, cm')
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%find point at which range is minimum in window     
     
hold on
for i=1:length(s1)
    s1fmin(i)=find(s1distance(i,:)==min(s1distance(i,:)));
    plot(t(s1fmin(i)), s1distance(i, s1fmin(i)), 'ko')
end
for i=1:length(s2)
s2fmin(i)=find(s2distance(i,:)==min(s2distance(i,:)));
    plot(t(s2fmin(i)), s2distance(i, s2fmin(i)), 'ko')

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot range vs speed
figure
hold on

for i=1:length(s1)
    plot(s1distance(i, 1:s1fmin(i)), s1speed(i, 1:s1fmin(i)), 'r')
    plot(s1distance(i, s1fmin(i)), s1speed(i, s1fmin(i)), 'r.', 'markersize', 30)
end
for i=1:length(s2)
    plot(s2distance(i, 1:s2fmin(i)), s2speed(i, 1:s2fmin(i)), 'b')
    plot(s2distance(i, s2fmin(i)), s2speed(i, s2fmin(i)), 'b.', 'markersize', 30)
end
xlabel('distance to target, cm')
ylabel('speed, cm/s')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot xy tracks, from sound onset to range min

figure
hold on
title(name, 'interpreter', 'none')
%all tracks in background
grey=[.8 .8 .8];
plot( xy(:,1), xy(:,2), 'color', grey)
axis equal
set(gca, 'ydir', 'reverse')

for i=1:length(s1)
    plot( s1tracks(i,1:s1fmin(i),1), s1tracks(i,1:s1fmin(i),2), 'r')
    text( s1tracks(i,1,1)+10, s1tracks(i,1,2), int2str(i), 'color', 'r')
    plot( s1tracks(i,prewin+1,1), s1tracks(i,prewin+1,2), 'k*')
%     plot( s1tracks(i,end,1), s1tracks(i,end,2), 'rx', 'markersize', 10)
    plot( s1tracks(i,s1fmin(i),1), s1tracks(i,s1fmin(i),2), 'r.', 'markersize', 40)
    text( s1tracks(i,s1fmin(i),1), s1tracks(i,s1fmin(i),2), int2str(i), 'color', 'k')
    
end
for i=1:length(s2)
    plot( s2tracks(i,1:s2fmin(i),1), s2tracks(i,1:s2fmin(i),2), 'b')
%     plot( s2tracks(i,1,1), s2tracks(i,1,2), 'ko')
    text( s2tracks(i,1,1)+10, s2tracks(i,1,2), int2str(i), 'color', 'b')

    plot( s2tracks(i,prewin+1,1), s2tracks(i,prewin+1,2), 'k*')
%     plot( s2tracks(i,end,1), s2tracks(i,end,2), 'bx', 'markersize', 10)
    plot( s2tracks(i,s2fmin(i),1), s2tracks(i,s2fmin(i),2), 'b.', 'markersize', 40)
    text( s2tracks(i,s2fmin(i),1), s2tracks(i,s2fmin(i),2), int2str(i), 'color', 'k')
end

%legend
plot(1400, 1000, 'ro')
text(1420, 1000, 'Spk1')
plot(1400, 950, 'bo')
text(1420, 950, 'Spk2')

%plot speaker location - this is hard-coded, need to update if we change
%arena or speaker
speaker1x=1e3*[    1.3869    1.3815    1.3657    1.3404    1.3076    1.2693    1.2282    1.1871    1.1489    1.1160    1.0908    1.0749    1.0695    1.0749    1.0908    1.1160    1.1489    1.1871    1.2282    1.2693    1.3076    1.3404    1.3657    1.3815    1.3869];
speaker1y=[286.4480  327.5252  365.8032  398.6732  423.8952  439.7504  445.1584  439.7504  423.8952  398.6732  365.8032  327.5252  286.4480  245.3707  207.0928  174.2228  149.0007  133.1455  127.7376  133.1455  149.0007  174.2228  207.0928  245.3707  286.4480];
speaker2x=[ 568.3122  562.9043  547.0491  521.8270  488.9570  450.6791  409.6018  368.5245  330.2466  297.3766  272.1546  256.2993  250.8914  256.2993  272.1546  297.3766  330.2466  368.5245  409.6018  450.6791  488.9570  521.8270  547.0491  562.9043  568.3122];
speaker2y=[ 815.2851  856.3623  894.6403  927.5103  952.7323  968.5875  973.9955  968.5875  952.7323  927.5103  894.6403  856.3623  815.2851  774.2078  735.9299  703.0599  677.8378  661.9826  656.5747  661.9826  677.8378  703.0599  735.9299  774.2078  815.2851];
speaker1mx=mean(speaker1x);
speaker1my=mean(speaker1y);
speaker2mx=mean(speaker2x);
speaker2my=mean(speaker2y);
plot(speaker1x, speaker1y, 'r:', speaker2x, speaker2y,'b:', speaker1mx, speaker1my, 'r*', speaker2mx, speaker2my,'b*' )
shg


     













