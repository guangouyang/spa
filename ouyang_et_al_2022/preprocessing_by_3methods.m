clear;

data_path = 'sample_data\';

temp = dir([data_path,'*.set']);
subs = unique(cellfun(@(x) x(1:11),{temp.name},'UniformOutput',false));


cd .......\eeglab2019_1\plugins\clean_rawdata2.1\private
%you need to nevigate to the above folder in order to use relevant
%functions in ASR

epoch_twd = [-200,800];
bl_twd = [-200,0];

task = 'visual_oddball';markers = {'S 21','S 22','S 23'};


proced_path = ['D:\Dropbox\work\projects\SPOAR\proced_data\',task,'\'];mkdir(proced_path);

%SPA
vars = [];


n = length(subs);
intervals = [];

for j = 1:n
    disp(j);
    EEG0 = pop_loadset([subs{j},'_',task,'.set'],[data_path,'cut\',task,'\']);
    EEG0 = pop_eegfiltnew(EEG0, 'locutoff',1,'hicutoff',40,'plotfreqz',0);
    EEG0 = pop_reref( EEG0, []);
    
    EEG = EEG0;
    idx = ismember({EEG.event.type},markers);
    latency = round([EEG.event(idx).latency]);
%     latency(latency>size(EEG.data,2)-round(epoch_twd(2)*EEG.srate/1000)) = [];
    vars = [];
    tic
    for k = 1:length(latency)
        [a,b,c] = pca(EEG.data(:,(latency(k)+round(EEG.srate*epoch_twd(1)/1000)):(latency(k)+round(EEG.srate*epoch_twd(2)/1000)))');
        vars(:,k) = c;
        b(:,c>(30)^2) = 0;
        EEG.data(:,(latency(k)+round(EEG.srate*epoch_twd(1)/1000)):(latency(k)+round(EEG.srate*epoch_twd(2)/1000))) = (b*a')';
    end
    intervals(j) = toc;
    pop_saveset(EEG,'filename',[subs{j},'_proced_by_SPA.set'],'filepath',proced_path);
    
    
    
end


%ICA and ASR
intervals = [];
intervals1 = [];

for j = 1:n
    disp(j);
    EEG = pop_loadset([subs{j},'_',task,'.set'],[data_path,'cut\',task,'\']);
    EEG0 = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',40,'plotfreqz',0);
    EEG0 = pop_reref( EEG0, []);
    
    EEG = EEG0;
    tic
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'stop',0.001,'interrupt','on');
    intervals(j) = toc;
    [comps,info] = MARA(EEG);
    EEG = pop_subcomp( EEG, comps, 0);
    
    
    pop_saveset(EEG,'filename',[subs{j},'_proced_by_ICA.set'],'filepath',proced_path);
    
    state = asr_calibrate(EEG.data,EEG.srate,10);
    
    signal = EEG0;
    windowlen = 1;
    stepsize = floor(signal.srate*windowlen/2);
    
    sig = [signal.data bsxfun(@minus,2*signal.data(:,end),signal.data(:,(end-1):-1:end-round(windowlen/2*signal.srate)))];
    
    tic
    [signal.data,state] = asr_process(sig,signal.srate,state,windowlen,windowlen/2,stepsize);
    signal.data(:,1:size(state.carry,2)) = [];
    intervals1(j) = toc;
    
    EEG = signal;
    pop_saveset(EEG,'filename',[subs{j},'_proced_by_ASR.set'],'filepath',proced_path);
    
    
    
    
    
end
