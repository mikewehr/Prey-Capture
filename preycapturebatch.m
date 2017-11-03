%batch process prey capture files

files=preycapturefilelist;
for i=1:length(files)
   AnalyzeBonsaiTrackingData( files(i).datapath, files(i).start_frame, files(i).stop_frame)
end