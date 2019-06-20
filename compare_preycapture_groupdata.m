function compare_preycapture_groupdata
% compare Range (and possibly other variables)
%across groupdata files from different conditions (like saline, lidocaine,
%unilateral, etc)

% groupdatadir= 'D:\lab\Data\lidocaine_groupdata';
% groupdatadir= 'D:\lab\Data\muscimol_groupdata';
groupdatadir= 'D:\lab\Data\unilateral_groupdata';
cd(groupdatadir)
distancecal=.05;

%compile Range from one groupdata file
% groupdatafilename='preycapture_groupdata_saline';
% groupdatafilename='preycapture_groupdata_lidocaine';
% groupdatafilename='preycapture_groupdata_muscimol';
groupdatafilename='preycapture_groupdata_lidocaine_right';
load(groupdatafilename)
groupdata=groupdata_all; %convert for deep lab cut 
framerate=groupdata(1).framerate;
Range=[];
for i=1:length(groupdata)
    range=groupdata(i).range;
    range=range*distancecal;  %convert to cm
    Range=[Range; range(1:end-1)];
    FirstContact(i)=groupdata(i).firstcontact_frame/framerate; %time to first contact in seconds
end
FirstContact_unilat_lidocaine_right=FirstContact;
Range_unilat_lidocaine_right=Range;
nlidocainerighttrials=length(groupdata);

% FirstContact_bilat_saline=FirstContact;
% Range_bilat_saline=Range;
% nsalinetrials=length(groupdata);

%compile Range from another groupdata file
% groupdatafilename='preycapture_groupdata_lidocaine';
groupdatafilename='preycapture_groupdata_muscimol';
% groupdatafilename='preycapture_groupdata_saline';
load(groupdatafilename)
groupdata=groupdata_all; %convert for deep lab cut 
Range=[];

for i=1:length(groupdata)
    range=groupdata(i).range;
    range=range*distancecal;  %convert to cm
    Range=[Range; range(1:end-1)];
    FirstContact(i)=groupdata(i).firstcontact_frame/framerate; %time to first contact in seconds
end
Range_muscimol=Range;
nmuscimoltrials=length(groupdata);
FirstContact_muscimol=FirstContact;

% Range_bilat_lidocaine=Range;
% nlidocainetrials=length(groupdata);
% FirstContact_bilat_lidocaine=FirstContact;

% Range_bilat_lidocaine=Range;
% nlidocainetrials=length(groupdata);
% FirstContact_bilat_lidocaine=FirstContact;

% [ns, xs]=hist(Range_bilat_saline, 100);
[ns, xs]=hist(Range_unilat_lidocaine_right, 100); %raw histogram of range for every frame
[nl, xl]=hist(Range_muscimol, 100);
 nnlf=nl/length(Range_muscimol); %normalized to number of frames
 nnsf=ns/length(Range_unilat_lidocaine_right);
%  nnsf=ns/length(Range_bilat_saline);
nnl=nl/nmuscimoltrials; %normalized to number of trials
nns=ns/nlidocainerighttrials;
% nns=ns/nsalinetrials;

figure
plot(xs, nns, xl, nnl)
legend('lidocaine right', 'muscimol')
title('Range, normalized to number of trials')

figure
plot(xs, nnsf, xl, nnlf)
legend('lidocaine right', 'muscimol')
title('Range, normalized to number of frames')

[nFCs, xFCs]=hist(FirstContact_unilat_lidocaine_right, 50); 
% [nFCs, xFCs]=hist(FirstContact_bilat_saline, 50); % histogram of first contact time for every frame
[nFCl, xFCl]=hist(FirstContact_muscimol, 50);
figure
plot(xFCs, nFCs, xFCl, nFCl)
legend('lidocaine right', 'muscimol')
% title(sprintf('first contact time, \nsaline: median %.2f +- %.2f s, lidocaine: %.2f +- %.2f s',...
title(sprintf('first contact time, \nslidocaineright: median %.2f +- %.2f s, muscimol: %.2f +- %.2f s',...
    median(FirstContact_unilat_lidocaine_right), ...
    std(FirstContact_unilat_lidocaine_right), ...
    median(FirstContact_muscimol), ...
    std(FirstContact_muscimol) ...
    ))
%   std(FirstContact_bilat_saline), ...
%   median(FirstContact_bilat_saline), ...

if 1    
    outpsfilename= sprintf('%s_plots.ps',groupdatafilename); 
    delete (outpsfilename)
    for f=1:get(gcf, 'Number')
        figure(f)
        print ('-dpsc2', '-append', outpsfilename)
    end
    fprintf('\nwrote %s in directory %s', outpsfilename, pwd)
end







