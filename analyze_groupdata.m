%look at prey capture video tracking groupdata
%groupdata generated by AnalyzeBonsaiTrackingData
%which is called by preycapturebatch using file list preycapturefilelist

clear
%groupdatadir= 'C:\Users\lab\Desktop\Legless crickets\combinedlegless';
groupdatadir= 'D:\lab\Data\Legless crickets\combinedlegless';
%groupdatadir= 'D:\lab\Data\826 mice bonsai';

%mount wehrrig4
%system('mount_smbfs smb://wehrrig4/C /Volumes/C')
close all

groupdatafilename='preycapture_groupdata';

%adjust filenames to work on a mac
if ismac
    groupdatadir= strrep(groupdatadir, '\', '/');
    groupdatadir= strrep(groupdatadir, 'C:', '/Volumes/C');
    groupdatadir= strrep(groupdatadir, 'D:', '/Volumes/D');
    
end

cd(groupdatadir)
load(groupdatafilename)
numfiles=length(groupdata);
fprintf('\nanalyzing %d files', numfiles)

% june 28 2018
% 1 pixel = .5 mm = .05 cm
% 1 mm = 2 pixels
% speeds were calculate in AnalyzeBonsaiTrackingData as pixels/frame
% conversion factor is (.05 cm/pixel)*(30 frames/s) = 1.5
% speed in cm/s = (speed in pixels/frame)*speedcal
% range in cm = range in pixels * distancecal
framerate=groupdata(1).framerate;
speedcal=.05*framerate;
distancecal=.05;

Range=[];
Speed=[];
CSpeed=[];
Azimuth=[];
T=[];
Numframes=[];

for i=1:length(groupdata)
    Numframes(i)=groupdata(i).numframes;
end
maxnumframes=max(Numframes);

%matrices to hold range etc. on each trial
RangeM=nan*ones(numfiles, maxnumframes);
SpeedM=RangeM;
CSpeedM=RangeM;
AzimuthM=RangeM;

RangeM2=RangeM;
SpeedM2=RangeM;
CSpeedM2=RangeM;
AzimuthM2=RangeM;


for i=1:length(groupdata)
    if ~mod(i,10)
        fprintf('\nfile %d/%d', i, numfiles)
    end
    
    range=groupdata(i).range;
    range=range*distancecal;  %convert to cm
    speed=groupdata(i).speed;
    speed=speed*speedcal; %convert to cm/s
    cspeed=groupdata(i).cspeed;
    cspeed=cspeed*speedcal; %convert to cm/s
    t=groupdata(i).t;
    azimuth=groupdata(i).azimuth;
    Range=[Range; range(1:end-1)];
    T=[T t(1:end-1)];
    Speed=[Speed; speed];
    CSpeed=[CSpeed; cspeed];
    Azimuth=[Azimuth; azimuth(1:end-1)];
    numframes=groupdata(i).numframes;
    
    %matrices aligned to capture
    RangeM(i,maxnumframes-numframes+1:maxnumframes)=range;
    SpeedM(i,maxnumframes-numframes+2:maxnumframes)=speed;
    CSpeedM(i,maxnumframes-numframes+2:maxnumframes)=cspeed;
    AzimuthM(i,maxnumframes-numframes+1:maxnumframes)=azimuth;
    
    %matrices aligned to cricket drop
    RangeM2(i,1:numframes)=range;
    SpeedM2(i,1:numframes-1)=speed;
    CSpeedM2(i,1:numframes-1)=cspeed;
    AzimuthM2(i,1:numframes)=azimuth;
    
    
    %recompute xcorr but thresholding for cricket speed
    maxlag=1*framerate;
    thresh=25;
    cspeed_th=nan(size(cspeed));
    x=find(cspeed>thresh);
    cspeed_th(x)=cspeed(x);
    
    %grow to +- 1 s window around jumps
    win=1; %seconds
    for y=x(:)'
        start=y-win*framerate;
        if start<1 start=1;end
        stop=y+win*framerate;
        if stop>=numframes-1 stop=numframes-1;end
        cspeed_th(start:stop)= cspeed(start:stop);
    end
    cspeed_th(isnan(cspeed_th))=0; %this artificially sets speed to zero more than 1s from where cricket is below thresh
    
    %in order to compute xcorr of cricket speed -> mouse speed, conditioned
    %on whether the range is below some threshold, prepare cricket and
    %mouse speed conditioned on range below threshold
    cspeed_rth=nan(size(cspeed)); %rth = "range theshold"
    mspeed_rth=nan(size(cspeed));
    rthresh=50;
    x=find(range<rthresh);
    x=x(x<=length(cspeed_rth)); %trim to size of speed vector
    cspeed_rth(x)=cspeed(x);
    mspeed_rth(x)=speed(x);
    mspeed_rth(isnan(mspeed_rth))=0; %this artificially sets speed to zero wherever range is above thresh (xcorr cannot accept nans)
    cspeed_rth(isnan(cspeed_rth))=0; %this artificially sets speed to zero wherever range is above thresh (xcorr cannot accept nans)
    
    
    [xc1, lag]=xcorr(speed, cspeed, maxlag, 'unbiased');%unbiased
    [xc1_th, lag]=xcorr(speed, cspeed_th, maxlag, 'unbiased');%unbiased
    [xc1_rth, lag]=xcorr(mspeed_rth, cspeed_rth, maxlag, 'unbiased');%unbiased
    [xc2, lag]=xcorr(range, cspeed, maxlag);%unbiased
    [xc2_th, lag]=xcorr(range, cspeed_th, maxlag);%unbiased
    [xc3, lag]=xcorr(range, speed, maxlag);%unbiased
    xc1=xc1- mean(xc1);
    xc1=xc1./max(abs(xc1));
    xc1_th=xc1_th- mean(xc1_th);
    xc1_th=xc1_th./max(abs(xc1_th));
    xc1_rth=xc1_rth- mean(xc1_rth);
    xc1_rth=xc1_rth./max(abs(xc1_rth));
    xc2=xc2- mean(xc2);
    xc2=xc2./max(abs(xc2));
    xc2_th=xc2_th- mean(xc2_th);
    xc2_th=xc2_th./max(abs(xc2_th));
    xc3=xc3- mean(xc3);
    xc3=xc3./max(abs(xc3));
    
    XC1(i,:)=xc1;
    XC2(i,:)=xc2;
    XC1_th(i,:)=xc1_th;
    XC1_rth(i,:)=xc1_rth;
    XC2_th(i,:)=xc2_th;
    XC3(i,:)=xc3;
    
end

lag=1000*lag/framerate;
%plot average xcorrs of mouse speed, cricket speed, and range
figure;hold on
semxc1=std(XC1)./sqrt(numfiles);
semxc2=std(XC2)./sqrt(numfiles);
semxc1_th=nanstd(XC1_th)./sqrt(numfiles);
semxc1_rth=nanstd(XC1_rth)./sqrt(numfiles);
semxc2_th=nanstd(XC2_th)./sqrt(numfiles);
semxc3=std(XC3)./sqrt(numfiles);

p=plot(0,0, 'b.', 0,0, 'c.', 0,0, 'k.',0,0, 'r.',0,0, 'm.', 0,0, 'g.') ;%dummy for legend
set(p, 'markersize', 20)
legend('cricket speed -> mouse speed','cricket speed th -> mouse speed',...
    'cricket speed (range th) -> mouse speed (range th)',...
    'cricket speed -> range','cricket speed th -> range','mouse speed -> range', ...
    'location', 'SouthOutside')
%set(p, 'vis', 'off')

shadedErrorBar(lag, mean(XC1), semxc1, 'lineprops', 'b', 'transparent', 1);
shadedErrorBar(lag, nanmean(XC1_th), semxc1_th,'lineprops', 'c', 'transparent', 1);
shadedErrorBar(lag, nanmean(XC1_rth), semxc1_rth,'lineprops', 'k', 'transparent', 1);
shadedErrorBar(lag, mean(XC2), semxc2,'lineprops', 'r', 'transparent', 1);
shadedErrorBar(lag, nanmean(XC2_th), semxc2_th,'lineprops', 'm', 'transparent', 1);
shadedErrorBar(lag, mean(XC3), semxc3,'lineprops', 'g', 'transparent', 1);
grid on
title('xcorr of mouse speed and cricket speed')
xlabel('time lag, ms')


%2-D histogram of azimuth vs range
Azimuthedges=linspace(0, 180, 10);
Rangeedges=linspace(0, 25, 10);
histmat=hist2(Azimuth, Range, Azimuthedges, Rangeedges);
figure;
pcolor(Azimuthedges,Rangeedges,histmat');
shading interp
xlabel('Azimuth, degrees')
ylabel('Range, cm')
% colorbar ;
title(sprintf('Azimuth vs. Range, n=%d', numfiles))


% 2-D histogram of range vs speed
%histogram speeds 0-40 px/s  in 30 bins, and ranges 0-1200 px in 60 bins
Speededges=linspace(0, 20, 10);
Rangeedges=linspace(0, 25, 10);
histmat=hist2(Speed, Range, Speededges, Rangeedges);
figure;
pcolor(Speededges,Rangeedges,histmat');
shading interp
xlabel('mouse speed, cm/s')
ylabel('range, cm')
% colorbar ;
title(sprintf('Mouse Speed vs. Range, n=%d', numfiles))

% 2-D histogram of range vs cricket speed
%histogram speeds 0-40 px/s  in 30 bins, and ranges 0-1200 px in 60 bins
CSpeededges=linspace(0, 10, 10);
Rangeedges=linspace(0, 25, 10);
histmat=hist2(CSpeed, Range, CSpeededges, Rangeedges);
figure;
pcolor(CSpeededges,Rangeedges,histmat');
shading interp
xlabel('cricket speed, cm/s')
ylabel('range, cm')
% colorbar ;
title(sprintf('cricket Speed vs. Range, n=%d', numfiles))

% 2-D histogram of mouse speed vs cricket speed
%histogram speeds 0-40 px/s  in 30 bins, and ranges 0-1200 px in 60 bins
CSpeededges=linspace(0, 10, 10);
Speededges=linspace(0, 20, 10);
histmat=hist2(Speed, CSpeed, Speededges, CSpeededges);
figure;
pcolor(Speededges,CSpeededges,histmat');
shading interp
xlabel('mouse speed, cm/s')
ylabel('cricket speed, cm/s')
% colorbar ;
title(sprintf('mouse speed vs cricket Speed , n=%d', numfiles))





% population average range vs time, aligned to capture
figure
F=-size(RangeM,2)+1:1:0;
t=F/framerate;
shadedErrorBar(t, nanmean(RangeM), nanstd(RangeM), 'lineprops', 'b', 'transparent', 1);
xlim([-20 0])
xlabel('time to capture, s')
ylabel('range, cm')

% population average azimuth vs time, aligned to capture
figure
shadedErrorBar(t, nanmean(AzimuthM), nanstd(AzimuthM), 'lineprops', 'b', 'transparent', 1);
xlim([-20 0])
xlabel('time to capture, s')
ylabel('Azimuth, degrees')

% population average speed vs time, aligned to capture
figure
hold on
plot(0, 0, 'b.', 0, 0, 'r.') %dummy for legend
shadedErrorBar(t, nanmean(SpeedM), nanstd(SpeedM), 'lineprops', 'b', 'transparent', 1);
shadedErrorBar(t, nanmean(CSpeedM), nanstd(CSpeedM), 'lineprops', 'r', 'transparent', 1);
xlim([-20 0])
xlabel('time to capture, s')
ylabel('speed, cm/s')
legend('mouse speed', 'cricket speed')


% population average range vs time, aligned to cricket drop
figure
F=1:size(RangeM2,2);
t=F/framerate;
shadedErrorBar(t, nanmean(RangeM2), nanstd(RangeM2), 'lineprops', 'b', 'transparent', 1);
xlim([0 10])
xlabel('time from cricket drop, s')
ylabel('range, cm')

% % population average azimuth vs time, aligned to cricket drop
figure
shadedErrorBar(t, nanmean(AzimuthM2), nanstd(AzimuthM2), 'lineprops', 'b', 'transparent', 1);
xlim([0 10])
xlabel('time from cricket drop, s')
ylabel('Azimuth, degrees')

% % population average speed vs time, aligned to cricket drop
figure
hold on
plot(0, 0, 'b.', 0, 0, 'r.') %dummy for legend
shadedErrorBar(t, nanmean(SpeedM2), nanstd(SpeedM2), 'lineprops', 'b', 'transparent', 1);
shadedErrorBar(t, nanmean(CSpeedM2), nanstd(CSpeedM2), 'lineprops', 'r', 'transparent', 1);
xlim([0 10])
xlabel('time from cricket drop, s')
ylabel('speed, cm/s')
legend('mouse speed', 'cricket speed')

%%%%
figure
hist(Numframes/framerate, 50)
title(sprintf('Time to capture, median=%.1f s +- %.1f s', median(Numframes)/framerate, std(Numframes/framerate)/sqrt(numfiles)))
xlabel('time to capture, s')
ylabel('count')


%%%%%%%%%%%%%%%%%%
% look for motifs

%motifs are composed of elements (events). We can first identify the
%events, and then look for combinations of them.
%cricket starts to move
%cricket stops moving
%cricket jumps

cspeed_thresh=1;
i=find(CSpeed>cspeed_thresh); %i are the indices where cricket is moving

t=1:length(Speed);t=t/framerate; %t is in s
figure
hold on
plot(t, CSpeed, t(i), CSpeed(i), 'ro')
xlabel('time, s')
ylabel('cricket speed, cm/s')
xlim([0 200])
tt=t(i);
%tt are the times in s where cricket is moving

diffi=diff(i);
cspeed_onsetsi=[1; 1+find(diffi>1)];
cspeed_offsetsi=find(diffi>1);
%these are indexed into i, convert back into frames
cspeed_onsets=i(cspeed_onsetsi); %frames on which cricket starts moving
cspeed_offsets=i(cspeed_offsetsi); %frames on which cricket stops moving

stem(t(cspeed_onsets), 20*ones(size(cspeed_onsets)), 'go')
stem(t(cspeed_offsets), 20*ones(size(cspeed_offsets)), 'mo')

figure
plot(t, CSpeed)
xlabel('time, s')
ylabel('cricket speed, cm/s')
hold on
stem(t(cspeed_onsets), 20*ones(size(cspeed_onsets)), 'go')

k=0;
winstart=-200;
winstop=200;
for j=cspeed_onsets'
    if j>-winstart & j+winstop<length(Azimuth)
        k=k+1;
        Az_cspeedonset(k,:)=Azimuth(j+winstart:j+winstop);
        Range_cspeedonset(k,:)=Range(j+winstart:j+winstop);
    end
end

for j=cspeed_offsets'
    if j>-winstart & j+winstop<length(Azimuth)
        k=k+1;
        Az_cspeedoffset(k,:)=Azimuth(j+winstart:j+winstop);
        Range_cspeedoffset(k,:)=Range(j+winstart:j+winstop);
    end
end

figure
shadedErrorBar(winstart:winstop, mean(Az_cspeedonset), nanstd(Az_cspeedonset), 'lineprops', 'b', 'transparent', 1);
xlabel('frames relative to cricket starts moving')
ylabel('Azimuth')
grid on

figure
shadedErrorBar(winstart:winstop, mean(Range_cspeedonset), nanstd(Range_cspeedonset), 'lineprops', 'b', 'transparent', 1);
xlabel('frames relative to cricket starts moving')
ylabel('Range, cm')
grid on


figure
shadedErrorBar(winstart:winstop, mean(Az_cspeedoffset), nanstd(Az_cspeedoffset), 'lineprops', 'b', 'transparent', 1);
xlabel('frames relative to cricket stops moving')
ylabel('Azimuth')
grid on

figure
shadedErrorBar(winstart:winstop, mean(Range_cspeedoffset), nanstd(Range_cspeedoffset), 'lineprops', 'b', 'transparent', 1);
xlabel('frames relative to cricket stops moving')
ylabel('Range, cm')
grid on

% "target acquisition" is a critical event in the capture sequence
% could we detect that in the tracking data somehow and align to it?
% what is the signature of target acquisition?
% cricket goes from still to moving.
% mouse changes direction towards cricket
% this starts driving range down.

% let's say he needs to have been stopped for 1 second
still_dur_s=1; %how long in seconds the cricket needs to have been stopped
still_dur_frames=still_dur_s*framerate;
new_cspeed_onsets=[];

for j=cspeed_onsets' %frames
    if any (cspeed_onsets > j-still_dur_frames & cspeed_onsets <j) | ...
            any (cspeed_offsets > j-still_dur_frames & cspeed_offsets <j)
        %discard, he moved within window
    else
        %it's a candidate
        new_cspeed_onsets=[new_cspeed_onsets j];
        % these are the frames on which he started moving after having been still for still_dur
    end
end

%next we look in a 1-second window after cricket starts moving, and ask
%whether mouse changes direction towards cricket (azimuth decreases) and
%range decreases
response_win_s=1; %how long to look at changes in range and azimuth, in seconds
response_win_frames=response_win_s*framerate;
target_acquisitions=[];

k=0;
AZ=[];
RG=[];
TA=[]; %k's that pass criteria for target acquistion
fig=figure;
for j=new_cspeed_onsets %frames
    az=Azimuth(j:j+response_win_frames);
    rg=Range(j:j+response_win_frames);
    k=k+1;
    AZ(k,:)=az;
    RG(k,:)=rg;
    
    figure(fig)
    hold on
    plot((-20:50), CSpeed(j-20:j+50), 'c')
    plot((-20:50), Speed(j-20:j+50), 'r')
    %     plot((-20:50), Azimuth(j-20:j+50), 'm')
    plot((-20:50), Range(j-20:j+50), 'g')
    line([1 1], ylim, 'color', 'g') %onset
    %     plot((0:response_win_frames), az, 'm', 'linewidth', 2)
    plot((0:response_win_frames), rg, 'g', 'linewidth', 2)
    legend('crcket speed', 'mouse speed', 'azimuth', 'range','cricket starts moving', 'az' ,'rg')
    
    x=0:response_win_frames;
    X(:,1)=x;
    X(:,2)=ones(size(x));
    [B,BINT,R,RINT,STATS] = regress(az, X);
    plot(x, X*B)
    [B2,~,~,~,STATS2] = regress(rg, X);
    plot(x, X*B2)
    if B(1)<0 & STATS(3)<.05 %azimuth is significantly decreasing
        if B2(1)<0 & STATS2(3)<.05 %range is significantly decreasing
            TA=[TA k];
%             fprintf('\nhit')
        end
    end
    
    
end

%OK, TA contains the k indices that qualify as target acquisitions
%what next to analyze behavior re: target acquisitions?

%print group data plots to postscript file
if 0    
    delete groupdata_plots.ps
    for f=1:get(gcf, 'Number')
        figure(f)
        print -dpsc2 -append groupdata_plots.ps
    end
end





