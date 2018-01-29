%batch process prey capture files

files=preycapturefilelist;
cd ('C:\Users\lab\Desktop\826 mice bonsai')
delete analysis_plots.ps

for i=1:length(files)
   AnalyzeBonsaiTrackingData( files(i).datapath, files(i).start_frame, files(i).stop_frame)
end