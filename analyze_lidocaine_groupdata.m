files=lidocaine_preycapturefilelist

Lb=0;
Sb=0;
Lr=0;
Sr=0;
nanval=5*60*30;

clear lido_capturetimeR lido_capturetimeB saline_capturetimeR saline_capturetimeB
for i=1:length(files)
    if strcmp(files(i).drug, 'lidocaine')
        if strfind(files(i).datapath, 'Rick')
            Lr=Lr+1;
            
            if isnan(files(i).stop_frame)
                lido_capturetimeR(Lr)=nanval;
            else
                lido_capturetimeR(Lr)=files(i).stop_frame - files(i).start_frame;
            end
        elseif strfind(files(i).datapath, 'Blue')
            Lb=Lb+1;
            
            if isnan(files(i).stop_frame)
                lido_capturetimeB(Lb)=nanval;
            else
                lido_capturetimeB(Lb)=files(i).stop_frame - files(i).start_frame;
            end
            
        end
    elseif strcmp(files(i).drug, 'saline')
        if strfind(files(i).datapath, 'Rick')
        Sr=Sr+1;
        if isnan(files(i).stop_frame)
            saline_capturetimeR(Sr)=nanval;
        else
            saline_capturetimeR(Sr)=files(i).stop_frame - files(i).start_frame;
        end
                elseif strfind(files(i).datapath, 'Blue')
                Sb=Sb+1;
        if isnan(files(i).stop_frame)
            saline_capturetimeB(Sb)=nanval;
        else
            saline_capturetimeB(Sb)=files(i).stop_frame - files(i).start_frame;
        end
        end
    else
        error
    end
end

lido_capturetimeR=lido_capturetimeR/30;
lido_capturetimeB=lido_capturetimeB/30;
saline_capturetimeR=saline_capturetimeR/30;
saline_capturetimeB=saline_capturetimeB/30;

fprintf('\n%d lidocaine files (%d Rick, %d Blue)', Lr+Lb, Lr, Lb)
fprintf('\n%d saline files (%d Rick, %d Blue)', Sr+Sb, Sr, Sb)
fprintf('\nmean Rick lidocaine capture time %.2f +- %.2f', nanmean(lido_capturetimeR), nanstd(lido_capturetimeR))
fprintf('\nmean Rick saline capture time %.2f +- %.2f', nanmean(saline_capturetimeR), nanstd(saline_capturetimeR))
fprintf('\nmean Blue lidocaine capture time %.2f +- %.2f', nanmean(lido_capturetimeB), nanstd(lido_capturetimeB))
fprintf('\nmean Blue saline capture time %.2f +- %.2f', nanmean(saline_capturetimeB), nanstd(saline_capturetimeB))

fprintf('\nmean allmice lidocaine capture time %.2f +- %.2f', nanmean([lido_capturetimeB lido_capturetimeR]), nanstd([lido_capturetimeB lido_capturetimeR]))
fprintf('\nmean allmice saline capture time %.2f +- %.2f', nanmean([saline_capturetimeB saline_capturetimeR]), nanstd([saline_capturetimeB saline_capturetimeR]))

fprintf('\np=%.4f allmice ', ranksum([saline_capturetimeB saline_capturetimeR], [lido_capturetimeB lido_capturetimeR]))
fprintf('\np=%.4f Rick ', ranksum([ saline_capturetimeR], [ lido_capturetimeR]))
fprintf('\np=%.4f Blue ', ranksum([saline_capturetimeB ], [lido_capturetimeB ]))
p1= ranksum([saline_capturetimeB saline_capturetimeR], [lido_capturetimeB lido_capturetimeR]);
pR= ranksum([ saline_capturetimeR], [ lido_capturetimeR]);
pB= ranksum([saline_capturetimeB ], [lido_capturetimeB ]);

e=errorbar([1 2], [ nanmean([lido_capturetimeB lido_capturetimeR]) nanmean([saline_capturetimeB saline_capturetimeR]) ], [ nanstd([lido_capturetimeB lido_capturetimeR]) nanstd([saline_capturetimeB saline_capturetimeR]) ]);
set(e, 'marker', 'o')
xlim([0 3])

figure
hold on
e=errorbar([1 2], [ nanmean([lido_capturetimeB lido_capturetimeR]) nanmean([saline_capturetimeB saline_capturetimeR]) ], [ nanstd([lido_capturetimeB lido_capturetimeR]) nanstd([saline_capturetimeB saline_capturetimeR]) ]);
set(e, 'color', 'k')
plot( ones(size(saline_capturetimeB)), saline_capturetimeB  , 'bo')
set(gca, 'xtick', [1 2], 'xticklabel', {'lidocaine', 'saline'})
yl=ylim;
ylim([0 yl(2)])
ylabel('capture time, sec')
set(gca, 'fontsize', 16)

%we should plot effect as a function of time, to see if lidocaine could be
%wearing off
plot( .1+ones(size(saline_capturetimeR)), saline_capturetimeR, 'ro')
plot( 1+ones(size(lido_capturetimeB)), lido_capturetimeB, 'bo')
plot(  .1+1+ones(size(lido_capturetimeR)), lido_capturetimeR, 'ro')
set(e, 'marker', 'o')
% text(1, 0, 'saline')
% text(2, 0, 'lidocaine')
text(1.25, 150, sprintf('p=%.4f', pR), 'fontsize', 16, 'color', 'r')
text(1.25, 170, sprintf('p=%.3f', pB), 'fontsize', 16, 'color', 'b')

xlim([0 3])

figure
hold on
e=errorbar([1 2], [ nanmean([lido_capturetimeB lido_capturetimeR]) nanmean([saline_capturetimeB saline_capturetimeR]) ], [ nanstd([lido_capturetimeB lido_capturetimeR]) nanstd([saline_capturetimeB saline_capturetimeR]) ]);
set(e, 'linestyle', 'none');
b=bar([1 2], [ nanmean([lido_capturetimeB lido_capturetimeR]) nanmean([saline_capturetimeB saline_capturetimeR]) ]);
set(gca, 'xtick', [1 2], 'xticklabel', {'lidocaine', 'saline'})
xlim([0 3])
yl=ylim;
ylim([0 yl(2)])
ylabel('capture time, sec')
text(1.5, 150, sprintf('p=%.3f', p1), 'fontsize', 16)

set(gca, 'fontsize', 16)











