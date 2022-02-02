function [sig_1,sig_2] = smooth_fusing_epochs(sig_1,sig_2,smooth_para)

sig_1 = sig_1(:);
sig_2 = sig_2(:);
m_point = (sig_1(end)+sig_2(1))/2;


L1 = length(sig_1);
L1_half = fix(L1/2);
L2 = length(sig_2);
L2_half = fix(L2/2);

dif_1 = linspace(0,1,L1_half).^smooth_para;
dif_2 = linspace(1,0,L2_half).^smooth_para;

dif_m1 = sig_1(end) - m_point;
dif_m2 = sig_2(1) - m_point;


sig_1(L1_half+1:end) = sig_1(L1_half+1:end) - dif_1'.*dif_m1;
sig_2(1:L2_half) = sig_2(1:L2_half) - dif_2'.*dif_m2;









