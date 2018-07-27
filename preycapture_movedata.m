%batch process prey capture files

%files=leglesscricketsfilelist;
%analysis_dir= 'C:\Users\lab\Desktop\Legless crickets\combinedlegless';

files=preycapturefilelist;
% files=leglesscricketsfilelist;

fprintf('\nAnalyzing %d files...', length(files))

target_dir='/Users/mikewehr/Dropbox/Prey Capture Data/826 mice bonsai'
% target_dir='/Users/mikewehr/Dropbox/Prey Capture Data/combined legless'

for i=1:length(files)
    fn=files(i).datapath;
    
     fn= strrep(fn, '\', '/');
    fn= strrep(fn, 'D:', '/Volumes/D');
    fn= strrep(fn, 'C:', '/Volumes/D');
    fn= strrep(fn, 'Users/lab/Desktop', 'lab/Data');
    
% copy txt file to new location
%     str=sprintf('cp ''%s'' ''%s''', fn, target_dir)
%     system(str)
    
% copy avi file to new location
fn=strrep(fn, '.txt', '.avi')
fn=strrep(fn, 'data', 'MT')


%     str=sprintf('cp ''%s'' ''%s''', fn, target_dir)
%     system(str)
    

   if ~mod(i,10)
       fprintf('\nfile %d/%d', i, length(files))
   end
end