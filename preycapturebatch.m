%batch process prey capture files

files=preycapturefilelist;
analysis_plots_dir= 'C:\Users\lab\Desktop\826 mice bonsai';
if ismac    
    analysis_plots_dir= strrep(analysis_plots_dir, '\', '/');
    analysis_plots_dir= strrep(analysis_plots_dir, 'C:', '/Volumes/C');
end
cd(analysis_plots_dir)
delete analysis_plots.ps
delete preycapture_groupdata.mat
fprintf('\nAnalyzing %d files...', length(files))

for i=1:length(files)
   AnalyzeBonsaiTrackingData( files(i).datapath, files(i).start_frame, files(i).stop_frame)
   
   if ~mod(i,10)
       fprintf('\nfile %d/%d', i, length(files))
   end
end