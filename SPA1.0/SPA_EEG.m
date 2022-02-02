function EEG = SPA_EEG(EEG,threshold,win_size,smooth_para)


s = win_size*EEG.srate;

segs = fix(size(EEG.data,2)/s);


data_new = EEG.data;jj = 0;
disp('SPA started.');
for j = 1:segs-1
    jj = jj+1;
    prog = fix(jj*100/segs);
    if prog > 10;disp([num2str(fix(j*100/segs)),'%']);jj = 0;end
    
    temp1 = EEG.data(:,(1+(j-1)*s):j*s);
    temp2 = EEG.data(:,(1+(j)*s):(j+1)*s);
    if j == segs-1 temp2 = EEG.data(:,(1+(j)*s):size(EEG.data,2));end
    
      [a,b,c] = pca(temp1');
      b(:,c>(threshold)^2) = 0;
      temp1 = (b*a')';
      [a,b,c] = pca(temp2');
      b(:,c>(threshold)^2) = 0;
      temp2 = (b*a')';
    
    
    for c = 1:size(EEG.data,1)
        [sig_1,sig_2] = smooth_fusing_epochs(temp1(c,:),temp2(c,:),smooth_para);
        data_new(c,(1+(j-1)*s):j*s) = sig_1';
        if j == segs-1 data_new(c,(1+(j)*s):size(EEG.data,2)) = sig_2;
        else
        data_new(c,(1+(j)*s):(j+1)*s) = sig_2';
        end
    end
end
EEG.data = data_new;
disp('SPA completed.');

    
    
    