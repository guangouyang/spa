clear;


EEG = pop_loadset('filename','sample_data.set','filepath','sample_data\');

pop_eegplot( EEG, 1, 1, 1);

EEG = SPA_EEG(EEG,30,2,2);

markers = {'S 22','S 21'}; 
epoch_twd = [-200,1000];
baseline_twd = [-200,0];
EEG = SPA_ERP(EEG,30,markers,epoch_twd,baseline_twd);

figure;
subplot(2,2,1);plot(EEG.t_axis,EEG.ERPs(:,:,1));
title('original ERP (S 22)');xlabel('time (ms)');xlim([-200,1000]);ylim([-20,20]);
subplot(2,2,2);plot(EEG.t_axis,EEG.ERPs(:,:,2));
title('original ERP (S 21)');xlabel('time (ms)');xlim([-200,1000]);ylim([-20,20]);
subplot(2,2,3);plot(EEG.t_axis,EEG.ERPs_SPA(:,:,1));
title('SPA ERP (S 22)');xlabel('time (ms)');xlim([-200,1000]);ylim([-20,20]);
subplot(2,2,4);plot(EEG.t_axis,EEG.ERPs_SPA(:,:,2));
title('SPA ERP (S 21)');xlabel('time (ms)');xlim([-200,1000]);ylim([-20,20]);






markers = {'S 22','S 21'}; 
epoch_twd = [-200,1000];
baseline_twd = [-200,0];
EEG = SPA_ERP(EEG,30,markers,epoch_twd,baseline_twd);


