function t = duration(stim)
%LOOMINGSTIM/DURATION
%
% 2015, Simon Lansbergen & Alexander Heimel
% 2025, Alexander Heimel & Huaxing Ou

par = getparameters(stim);
df = struct(getdisplayprefs(stim));
t = df.BGpretime + (par.expansion_time + par.static_time + par.inter_looming_time)*par.n_repetitions + df.BGposttime;

