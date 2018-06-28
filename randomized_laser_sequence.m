str={'on', 'on', 'on', 'on', 'on', 'off','off','off','off','off'} 

for k=1:10;
    r=randperm(10);

for i=1:10
    fprintf('\n%d: %s', i, str{r(i)})
end

fprintf('\n\n')
end