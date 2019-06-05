function out = LoadDeepCutTracks2(varargin)

temp = dir('Behavior*.mat');
load(temp.name);

if length(varargin) == 1
    NoEars = 1;
else
    NoEars = 0;
end

threshold = 0.9;

%%%%%%% Skytracking/Cleaning %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [snout] = clean(SkyTrack.Nose,threshold);
    try
        [left_ear] = clean(SkyTrack.Lear,threshold);
    catch
        [left_ear] = clean(SkyTrack.Lcam,threshold);
    end
    try
        [right_ear] = clean(SkyTrack.Rear,threshold);
    catch
        [right_ear] = clean(SkyTrack.Rcam,threshold);
    end
    [tail_base] = clean(SkyTrack.Ptail,threshold);
    [crick_head] = clean(SkyTrack.Chead,threshold);
    [crick_tail] = clean(SkyTrack.Cbutt,threshold);
    

    [snout] = interpolating(snout, 1);
    [snout] = interpolating(snout, 2);
    [left_ear] = interpolating(left_ear, 1);
    [left_ear] = interpolating(left_ear, 2);
    [right_ear] = interpolating(right_ear, 1);
    [right_ear] = interpolating(right_ear, 2);
    [tail_base] = interpolating(tail_base, 1);
    [tail_base] = interpolating(tail_base, 2);
    
    [crick_head] = interpolating(crick_head, 1);
    [crick_head] = interpolating(crick_head, 2);
    [crick_tail] = interpolating(crick_tail, 1);
    [crick_tail] = interpolating(crick_tail, 2);
    
    mouseNosexy=snout;
    mouseCOMxy=tail_base;
    cricketxy=crick_head;
    for i = 1:length(cricketxy)
        if isnan(cricketxy(i,1))                    %If cricket value is NaN,
            cricketxy(i,1) = mouseNosexy(i,1);            %replace it with mouse coordinate,
            cricketxy(i,2) = mouseNosexy(i,2);            %because it's probably right under their nose
        end
    end
    
    out.mouseCOMxy=mouseCOMxy;
    out.mouseNosexy=mouseNosexy;
    out.cricketxy=cricketxy;
    
%%%%%%% Eartracking/Cleaning %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NoEars == 0
    %clean:
    LcDorMed1 = clean(LearTrack.DorMed1, threshold);
    LcDorMed2 = clean(LearTrack.DorMed2, threshold);%AKA: 'Left,cleaned,DorMed
    LcDorLat1 = clean(LearTrack.DorLat1, threshold);
    LcDorLat2 = clean(LearTrack.DorLat2, threshold);
    LcDist = clean(LearTrack.Dist, threshold);      
    LcVenMed1 = clean(LearTrack.VenMed1, threshold);
    LcVenMed2 = clean(LearTrack.VenMed2, threshold);
    LcVenLat1 = clean(LearTrack.VenLat1, threshold);
    LcVenLat2 = clean(LearTrack.VenLat2, threshold);
    
    RcDorMed1 = clean(RearTrack.DorMed1, threshold);  %AKA: 'Right,cleaned,DorMed
    RcDorMed2 = clean(RearTrack.DorMed2, threshold);
    RcDorLat1 = clean(RearTrack.DorLat1, threshold);
    RcDorLat2 = clean(RearTrack.DorLat2, threshold);
    RcDist = clean(RearTrack.Dist, threshold);
    RcVenMed1 = clean(RearTrack.VenMed1, threshold);
    RcVenMed2 = clean(RearTrack.VenMed2, threshold);
    RcVenLat1 = clean(RearTrack.VenLat1, threshold);
    RcVenLat2 = clean(RearTrack.VenLat2, threshold);
    
    
    %interpolate:
    LiDorMed1 = interpolating(LcDorMed1, 1);
    LiDorMed1 = interpolating(LiDorMed1, 2);%AKA: 'Left,interpolated,DorMed
    LiDorMed2 = interpolating(LcDorMed2, 1);
    LiDorMed2 = interpolating(LiDorMed2, 2);
    LiDorLat1 = interpolating(LcDorLat1, 1);
    LiDorLat1 = interpolating(LiDorLat1, 2);
    LiDorLat2 = interpolating(LcDorLat2, 1);
    LiDorLat2 = interpolating(LiDorLat2, 2);
    LiDist = interpolating(LcDist, 1);              
    LiDist = interpolating(LiDist, 2);
    LiVenMed1 = interpolating(LcVenMed1, 1);
    LiVenMed1 = interpolating(LiVenMed1, 2);
    LiVenMed2 = interpolating(LcVenMed2, 1);
    LiVenMed2 = interpolating(LiVenMed2, 2);
    LiVenLat1 = interpolating(LcVenLat1, 1);
    LiVenLat1 = interpolating(LiVenLat1, 2);
    LiVenLat2 = interpolating(LcVenLat2, 1);
    LiVenLat2 = interpolating(LiVenLat2, 2);
    
    RiDorMed1 = interpolating(RcDorMed1, 1);          %AKA: 'Right,interpolated,DorMed
    RiDorMed1 = interpolating(RiDorMed1, 2);
    RiDorMed2 = interpolating(RcDorMed2, 1);          
    RiDorMed2 = interpolating(RiDorMed2, 2);
    RiDorLat1 = interpolating(RcDorLat1, 1);
    RiDorLat1 = interpolating(RiDorLat1, 2);
    RiDorLat2 = interpolating(RcDorLat2, 1);
    RiDorLat2 = interpolating(RiDorLat2, 2);
    RiDist = interpolating(RcDist, 1);               
    RiDist = interpolating(RiDist, 2);
    RiVenMed1 = interpolating(RcVenMed1, 1);
    RiVenMed1 = interpolating(RiVenMed1, 2);
    RiVenMed2 = interpolating(RcVenMed2, 1);
    RiVenMed2 = interpolating(RiVenMed2, 2);
    RiVenLat1 = interpolating(RcVenLat1, 1);
    RiVenLat1 = interpolating(RiVenLat1, 2);
    RiVenLat2 = interpolating(RcVenLat2, 1);
    RiVenLat2 = interpolating(RiVenLat2, 2);
    
    %transform to polar coordinates
    NewOrigin = [1,959]; %origin for left ear
    LiDorMed1 = MakePolar(NewOrigin,LiDorMed1);
    LiDorMed2 = MakePolar(NewOrigin,LiDorMed2);
    LiDorLat1 = MakePolar(NewOrigin,LiDorLat1);
    LiDorLat2 = MakePolar(NewOrigin,LiDorLat2);
    LiDist = MakePolar(NewOrigin,LiDist);
    LiVenMed1 = MakePolar(NewOrigin,LiVenMed1);
    LiVenMed2 = MakePolar(NewOrigin,LiVenMed2);
    LiVenLat1 = MakePolar(NewOrigin,LiVenLat1);
    LiVenLat2 = MakePolar(NewOrigin,LiVenLat2);
   
    for i = 1:length(LiDorMed1) %make polar average
        frame = [LiDorMed1(i,1),LiDorMed2(i,1),LiDorLat1(i,1), LiDorLat2(i,1),LiDist(i,1),LiVenLat1(i,1), LiVenLat2(i,1),LiVenMed1(i,1), LiVenMed2(i,1)];
        LiThetaAverage(i) = nanmean(frame);
    end

    NewOrigin = [1279,959]; %origin for right ear
    RiDorMed1 = MakePolar(NewOrigin,RiDorMed1);
    RiDorMed2 = MakePolar(NewOrigin,RiDorMed2);
    RiDorLat1 = MakePolar(NewOrigin,RiDorLat1);
    RiDorLat2 = MakePolar(NewOrigin,RiDorLat2);
    RiDist = MakePolar(NewOrigin,RiDist); 
    RiVenMed1 = MakePolar(NewOrigin,RiVenMed1);
    RiVenMed2 = MakePolar(NewOrigin,RiVenMed2);
    RiVenLat1 = MakePolar(NewOrigin,RiVenLat1);
    RiVenLat2 = MakePolar(NewOrigin,RiVenLat2);
    for i = 1:length(RiDorMed1) %make polar average
        frame = [RiDorMed1(i,1),RiDorMed2(i,1),RiDorLat1(i,1),RiDorLat2(i,1),RiDist(i,1),RiVenLat1(i,1),RiVenLat2(i,1),RiVenMed1(i,1),RiVenMed2(i,1)];
        RiThetaAverage(i) = nanmean(frame);
    end
    
    %put into 'out' structure:
    out.LcDorMed1=LcDorMed1;
    out.LcDorMed2=LcDorMed2;
    out.LcDorLat1=LcDorLat1;
    out.LcDorLat2=LcDorLat2;
    out.LcDist=LcDist;
    out.LcVenMed1=LcVenMed1;
    out.LcVenMed2=LcVenMed2;
    out.LcVenLat1=LcVenLat1;
    out.LcVenLat2=LcVenLat2;
    out.LiDorMed1=LiDorMed1;
    out.LiDorMed2=LiDorMed2;
    out.LiDorLat1=LiDorLat1;
    out.LiDorLat2=LiDorLat2;
    out.LiDist=LiDist;
    out.LiVenMed1=LiVenMed1;
    out.LiVenMed2=LiVenMed2;
    out.LiVenLat1=LiVenLat1;
    out.LiVenLat2=LiVenLat2;
    out.LiThetaAverage = LiThetaAverage';
    
    out.RcDorMed1=RcDorMed1;
    out.RcDorMed2=RcDorMed2;
    out.RcDorLat1=RcDorLat1;
    out.RcDorLat2=RcDorLat2;
    out.RcDist=RcDist;
    out.RcVenLat1=RcVenLat1;
    out.RcVenLat2=RcVenLat2;
    out.RcVenMed1=RcVenMed1;
    out.RcVenMed2=RcVenMed2;
    out.RiDorMed1=RiDorMed1;
    out.RiDorMed2=RiDorMed2;
    out.RiDorLat1=RiDorLat1;
    out.RiDorLat2=RiDorLat2;
    out.RiDist=RiDist;
    out.RiVenLat1=RiVenLat1;
    out.RiVenLat2=RiVenLat2;
    out.RiVenMed1=RiVenMed1;
    out.RiVenMed2=RiVenMed2;
    out.RiThetaAverage = RiThetaAverage';
else
end
    
    
%%%%%%%save
    save('out', 'out')
    
end

%%%%%%%%%%%%%%%%%%% Functions used in this function %%%%%%%%%%%%%%%%%%%
function [confident] = clean(point,threshold)
probability = point(:, 3);
I = find(probability < threshold) ;
point(I, 1:2) = NaN ;
confident = point ;
end
function [point] = interpolating(point, XorY)

goodpointRows = find(~isnan(point(:, XorY))); %Where points are good
querypoints = find(isnan(point(:, XorY))); % where we want to fill in (Nan)
abovethresh = point(goodpointRows,XorY) ; % good x values

try
    interpolated = interp1(goodpointRows,abovethresh, querypoints);
catch
    interpolated = nan(size(querypoints));
end
point(querypoints, XorY)=interpolated;
end
function [newpoint] = MakePolar(NewOrigin,point)
    point = point(:,1:2);
    newpoint = point-NewOrigin;
    newpoint(:,2) = ((newpoint(:,2))*(-1));
    [TH,R] = cart2pol(newpoint(:,1),newpoint(:,2));
    newpoint = [TH,R];
end