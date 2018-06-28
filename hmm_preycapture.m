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

i=1;


range=groupdata(i).range;
speed=groupdata(i).speed;
cspeed=groupdata(i).cspeed;
t=groupdata(i).t;
azimuth=groupdata(i).azimuth;
numframes=groupdata(i).numframes;
smouseCOMx=groupdata(i).smouseCOMx ;
smouseCOMy=groupdata(i).smouseCOMy ;
scricketx=groupdata(i).scricketx ;
scrickety=groupdata(i).scrickety;

seq(1,:)=smouseCOMx;
seq(2,:)=smouseCOMy;
seq(3,:)=scricketx;
seq(4,:)=scrickety;

figure
hold on
plot(smouseCOMx, smouseCOMy)
plot(scricketx, scrickety)

TRANS_GUESS = [.85 .15; .1 .9];
EMIS_GUESS = [.17 .16 .17 .16 .17 .17;.6 .08 .08 .08 .08 08];

[TRANS_EST2, EMIS_EST2] = hmmtrain(seq, TRANS_GUESS, EMIS_GUESS)
