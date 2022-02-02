function EEG = SPA_ERP(EEG,threshold,markers,epoch_twd,baseline_twd)

epoch_twd_d = round(epoch_twd*EEG.srate/1000);
ST = {};
ST_SPA = {};
bl = 1+round((baseline_twd(1) - epoch_twd(1))*EEG.srate/1000):round((baseline_twd(2) - epoch_twd(1))*EEG.srate/1000);
for m = 1:length(markers)
latencies = round([EEG.event(ismember({EEG.event.type},markers{m})).latency]);
ST{m} = [];
ST_SPA{m} = [];
for j = 1:length(latencies)
    temp = EEG.data(:,(latencies(j)+epoch_twd_d(1)):(latencies(j)+epoch_twd_d(2)));
    ST{m}(:,:,j) = temp;
    [a,b,c] = pca(temp');
    b(:,c>(threshold)^2) = 0;
    temp = (b*a')';
    ST_SPA{m}(:,:,j) = temp;
end
ST{m} = ST{m} - mean(ST{m}(:,bl,:),2);
ST_SPA{m} = ST_SPA{m} - mean(ST_SPA{m}(:,bl,:),2);
end


%plot ERP S4 (rare) from Pz (and S5, frequent)
results.t_axis = linspace(epoch_twd(1),epoch_twd(2),size(ST{1},2));


for j = 1:length(ST)
    ERPs(:,:,j) = mean(ST{j},3);
    ERPs_SPA(:,:,j) = mean(ST_SPA{j},3);
end


EEG.ERPs = ERPs;
EEG.ST = ST;

EEG.ERPs_SPA = ERPs_SPA;
EEG.ST_SPA = ST_SPA;

EEG.t_axis = linspace(epoch_twd(1),epoch_twd(2),size(ST{1},2));
disp('SPA completed.');

    
    
    