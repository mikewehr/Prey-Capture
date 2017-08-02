function out = LoadBonsaiTracks(datapath, filename)



cd(datapath)
%check for outfile and load if present
[p, f, e]=fileparts(filename);
outfilename=sprintf('%s.mat', f);
txtfilename=sprintf('%s.txt', f);
if exist(outfilename, 'file')
    load(outfilename)
elseif exist(txtfilename, 'file')
    
    
    fid=fopen(txtfilename);
    
    fseek(fid, 0, 1); %fastforward to end, to get file size
    filesize=ftell(fid);
    fseek(fid, 0, -1); %rewind to start
    wb=waitbar(0, 'loading raw bonsai tracks');
    
    
    
    
    i=0;
    while 1
        ln=fgetl(fid);
       if ~mod(i, 1000) waitbar(ftell(fid)/filesize, wb);end
        if ~ischar(ln), break, end
        ln2=strrep(ln, '(', '');
        ln3=strrep(ln2, ')', '');
        ln4=strsplit(ln3, ',');
        if length(ln4) ~= 6
            error('bonsai data does not have 6 elements?')
        end
        i=i+1;
        for j=1:6
            Mread(i,j)=str2num(ln4{j});
        end
        
    end
    
    fclose(fid);
    
    mouseCOMxy=Mread(:,1:2);
    mouseNosexy=Mread(:,3:4);
    cricketxy=Mread(:,5:6);
    
    
    out.mouseCOMxy=mouseCOMxy;
    out.mouseNosexy=mouseNosexy;
    out.cricketxy=cricketxy;
    save(outfilename, 'out')
    
    close(wb)
else error('file not found')
end