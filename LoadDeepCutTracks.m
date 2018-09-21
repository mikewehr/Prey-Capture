function out = LoadDeepCutTracks(datapath)

%check for outfile and load if present
cd(datapath)
outfilename=sprintf('out.mat');
if exist(outfilename, 'file')
    load(outfilename)
else
    
    snout=csvread('snout.csv', 1, 8);
    results=csvread('Results.csv', 1, 8);
    crick_tail=csvread('crick_tail.csv', 1, 8);
    right_ear=csvread('right_ear.csv', 1, 8);
    tail_base=csvread('tail_base.csv', 1, 8);
    crick_head=csvread('crick_head.csv', 1, 8);
    left_ear=csvread('left_ear.csv', 1, 8);
    left_ear=csvread('left_ear.csv', 1, 8);

   
%x and y are in columns 8 and 9    (0-indexed)





    mouseNosexy=snout;
    mouseCOMxy=tail_base;
    cricketxy=crick_head;
    
    out.mouseCOMxy=mouseCOMxy;
    out.mouseNosexy=mouseNosexy;
    out.cricketxy=cricketxy;
    save(outfilename, 'out')
    
end