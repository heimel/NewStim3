function [outstim] = loadstim(PSstim)
%periodicstim/loadstim
%
% 200X, Steve Van Hooser
% 2025, Alexander Heimel

% NewStimGlobals;
% PSstim = unloadstim(PSstim);
% PSparams = PSstim.PSparams;
% StimWindowGlobals;

outstim = loadstimPTB3(PSstim);
